defmodule EctoCooler.Templates.Migration do
  require EEx

  alias EctoCooler.Env

  EEx.function_from_file(
    :def,
    :generate,
    Path.expand("migration.eex", "lib/templates/migration"),
    [:assigns]
  )

  def create_migration([schema_name | [table_name | attributes]]) do
    app_name = Env.get(:app_name, "MyApp")
    # app_slug = Env.get(:app_slug, nil)

    binary_id =
      :generators
      |> Env.get([])
      |> Keyword.get(:binary_id, false)

    repo_name = Inflex.pluralize(schema_name)
    options = options(binary_id: binary_id)
    migration_dir = Env.get(:migration_dir, "priv/repo/migrations")

    assigns = %{
      app_name: app_name,
      repo_name: repo_name,
      options: options,
      table_name: table_name,
      fields: fields(attributes, binary_id)
    }

    content = generate(assigns)

    filename =
      Calendar.strftime(DateTime.utc_now(), "%Y%m%d%H%M%S") <> "_create_#{table_name}.exs"

    path = Path.expand(migration_dir)
    filepath = "#{path}/#{filename}"

    File.mkdir_p!(path)
    File.write!(filepath, content)

    {:ok, filepath}
  end

  def options(binary_id: false), do: nil
  def options(binary_id: true), do: ", primary_key: false"

  def fields(nil, false), do: fields([], false)
  def fields(nil, true), do: fields([], true)
  def fields([], true), do: [create_field(["id", "binary_id"])]
  def fields([], false), do: []

  def fields(attributes, true) do
    ["id:binary_id" | attributes]
    |> Enum.map(&create_field(&1))
  end

  def fields(attributes, false), do: Enum.map(attributes, &create_field(&1))

  defp create_field(attr) when is_binary(attr) do
    create_field(String.split(attr, ":"))
  end

  defp create_field(["id", _]) do
    "add :id, :binary_id, primary_key: true, null: false"
  end

  defp create_field([field, "references", table] = list) when is_list(list) do
    "add :#{field}, references(:#{table}#{reference_type(Env.get(:generators, []))}), null: false"
  end

  defp create_field([field, type, "null"] = list) when is_list(list) do
    "add :#{field}, :#{translate_type(type)}"
  end

  defp create_field([field, type] = list) when is_list(list) do
    "add :#{field}, :#{translate_type(type)}, null: false"
  end

  defp reference_type(binary_id: true), do: ", type: :binary_id"
  defp reference_type(_), do: nil

  defp translate_type("int"), do: "integer"
  defp translate_type("string"), do: "text"
  defp translate_type("bool"), do: "boolean"
  defp translate_type("json"), do: "map"
  defp translate_type(type), do: type
end
