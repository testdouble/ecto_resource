defmodule EctoResource.OptionParser do
  @functions %{
    all: %{
      arity: 1,
      name: "all",
      errorable: false
    },
    change: %{
      arity: 1,
      name: "change",
      errorable: false
    },
    create: %{
      arity: 1,
      name: "create",
      errorable: false
    },
    create!: %{
      arity: 1,
      name: "create",
      errorable: true
    },
    delete: %{
      arity: 1,
      name: "delete",
      errorable: false
    },
    delete!: %{
      arity: 1,
      name: "delete",
      errorable: true
    },
    get: %{
      arity: 2,
      name: "get",
      errorable: false
    },
    get!: %{
      arity: 2,
      name: "get",
      errorable: true
    },
    update: %{
      arity: 2,
      name: "update",
      errorable: false
    },
    update!: %{
      arity: 2,
      name: "update",
      errorable: true
    }
  }

  def parse(suffix, []) do
    @functions
    |> Map.keys()
    |> Enum.reduce(%{}, fn function, acc ->
      accumulate_functions(acc, suffix, function)
    end)
  end

  def parse(suffix, only: filters) do
    filters = add_error_filters(filters)

    @functions
    |> Map.keys()
    |> Enum.filter(fn function -> Enum.member?(filters, function) end)
    |> Enum.reduce(%{}, fn function, acc ->
      accumulate_functions(acc, suffix, function)
    end)
  end

  def parse(suffix, except: filters) do
    filters = add_error_filters(filters)

    @functions
    |> Map.keys()
    |> Enum.reject(fn function -> Enum.member?(filters, function) end)
    |> Enum.reduce(%{}, fn function, acc ->
      accumulate_functions(acc, suffix, function)
    end)
  end

  def parse(suffix, :read), do: parse(suffix, only: [:all, :get])
  def parse(suffix, :write), do: parse(suffix, only: [:change, :create, :update])
  def parse(suffix, :delete), do: parse(suffix, only: [:delete])

  defp accumulate_functions(acc, suffix, :all) do
    fn_map = @functions[:all]

    Map.put(acc, :all, %{
      resource: Inflex.pluralize(suffix),
      name: function_name(suffix, fn_map),
      description: function_description(suffix, fn_map)
    })
  end

  defp accumulate_functions(acc, suffix, function) do
    fn_map = @functions[function]

    Map.put(acc, function, %{
      resource: suffix,
      name: function_name(suffix, fn_map),
      description: function_description(suffix, fn_map)
    })
  end

  defp add_error_filters(filters) do
    Enum.reduce(filters, filters, fn filter, acc ->
      [:"#{filter}!" | acc]
    end)
  end

  defp function_name(suffix, %{name: "all"}) do
    suffix = Inflex.pluralize(suffix)
    :"all_#{suffix}"
  end

  defp function_name(suffix, %{name: name, errorable: true}),
    do: :"#{name}_#{suffix}!"

  defp function_name(suffix, %{name: name}),
    do: :"#{name}_#{suffix}"

  defp function_description(suffix, %{name: "all", arity: arity}) do
    suffix = Inflex.pluralize(suffix)
    "all_#{suffix}/#{arity}"
  end

  defp function_description(suffix, %{name: name, arity: arity, errorable: true}),
    do: "#{name}_#{suffix}!/#{arity}"

  defp function_description(suffix, %{name: name, arity: arity}),
    do: "#{name}_#{suffix}/#{arity}"
end
