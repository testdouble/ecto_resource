defmodule EctoCooler.Templates.Schema do
  require EEx

  alias EctoCooler.Env

  EEx.function_from_file(
    :def,
    :generate,
    Path.expand("schema.eex", "lib/templates/schema"),
    [:assigns]
  )

  def create_schema([schema_name | [table_name | attributes]]) do
    binary_id =
      :generators
      |> Env.get([])
      |> Keyword.get(:binary_id, false)

    instance_name = Inflex.singularize(table_name)
    app_name = Env.get(:app_name, "EctoCooler")

    assigns = %{
      app_name: app_name,
      schema_name: schema_name,
      schema_namespace: Env.get(:schema_namespace, "Schema"),
      binary_id: binary_id,
      table_name: table_name,
      instance_name: instance_name,
      fields: fields(attributes),
      attributes: validated_attributes(attributes)
    }

    content = generate(assigns)

    app_directory = Inflex.underscore(app_name)
    schema_dir = Env.get(:schema_dir, "lib/#{app_directory}/schema")
    path = Path.expand(schema_dir)
    filepath = "#{path}/#{instance_name}.ex"

    File.mkdir_p!(path)
    File.write!(filepath, content)
    {:ok, filepath}
  end

  def fields(nil), do: []
  def fields([]), do: []
  def fields(attributes), do: Enum.map(attributes, &create_field(&1))

  def validated_attributes(nil), do: []
  def validated_attributes([]), do: []

  def validated_attributes(attributes) do
    attributes
    |> Enum.map(&create_attribute(&1))
    |> Enum.reject(&is_nil(&1))
    |> Enum.join(", ")
  end

  defp create_field(attr) when is_binary(attr) do
    create_field(String.split(attr, ":"))
  end

  defp create_field([field, "references", _] = list) when is_list(list) do
    "field :#{field}, #{reference_type(Env.get(:generators, []))}"
  end

  defp create_field([field, type, "null"] = list) when is_list(list) do
    "field :#{field}, :#{type}"
  end

  defp create_field([field, type] = list) when is_list(list) do
    "field :#{field}, :#{type}"
  end

  defp reference_type(binary_id: true), do: ":binary_id"
  defp reference_type(_), do: ":integer"

  defp create_attribute(attribute) when is_binary(attribute) do
    create_attribute(String.split(attribute, ":"))
  end

  defp create_attribute([_, "references", _] = list) when is_list(list), do: nil
  defp create_attribute([_, _, "null"] = list) when is_list(list), do: nil
  defp create_attribute([attribute, _] = list) when is_list(list), do: ":#{attribute}"
end
