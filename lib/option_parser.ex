defmodule EctoResource.OptionParser do
  @moduledoc """
  This module provides a means to parse options given to `EctoResource.resource/2`
  into a map containing the set of functions to be generated in the using module.

  DO NOT USE this module. It is documented here for development purposes only!
  """

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

  @doc """
  Turns options (keyword list or atom) into a map containing all the CRUD functions
  to be generated.

  ## Examples
      iex> parse("user", only: [:create])

      %{
        create: %{
          name: :create_user,
          description: "create_user/1"
        },
        create!: %{
          name: :create_user!,
          description: "create_user!/1"
        }
      }

      iex> parse("user", except: [:change, :update, :delete, :get, :update, :all])

      %{
        create: %{
          name: :create_user,
          description: "create_user/1"
        },
        create!: %{
          name: :create_user!,
          description: "create_user!/1"
        }
      }

      iex> parse("user", :read)

      %{
        all: %{
          name: :all_users,
          description: "all_users/1"
        },
        get: %{
          name: :get_user,
          description: "get_user/2"
        },
        get!: %{
          name: :get_user!,
          description: "get_user!/2"
        }
      }

      iex> parse("user", :write)

      %{
        change: %{
          name: :change_user,
          description: "change_user/1"
        },
        create: %{
          name: :create_user,
          description: "create_user/1"
        },
        create!: %{
          name: :create_user!,
          description: "create_user!/1"
        },
        update: %{
          name: :update_user,
          description: "update_user/2"
        },
        update!: %{
          name: :update_user!,
          description: "update_user!/2"
        }
      }

      iex> parse("user", :delete)

      %{
        delete: %{
          name: :delete_user,
          description: "delete_user/1"
        },
        delete!: %{
          name: :delete_user!,
          description: "delete_user!/1"
        }
      }
  """
  @spec parse(String.t(), list() | atom()) :: map()
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

  @spec accumulate_functions(map(), String.t(), atom()) :: map()
  defp accumulate_functions(acc, suffix, function) do
    fn_map = @functions[function]

    Map.put(acc, function, %{
      name: function_name(suffix, fn_map),
      description: function_description(suffix, fn_map)
    })
  end

  @spec add_error_filters(list()) :: map()
  defp add_error_filters(filters) do
    Enum.reduce(filters, filters, fn filter, acc ->
      [:"#{filter}!" | acc]
    end)
  end

  @spec function_name(String.t(), map()) :: atom()
  defp function_name(suffix, %{name: "all"}) do
    suffix = Inflex.pluralize(suffix)
    :"all_#{suffix}"
  end

  defp function_name(suffix, %{name: name, errorable: true}),
    do: :"#{name}_#{suffix}!"

  defp function_name(suffix, %{name: name}),
    do: :"#{name}_#{suffix}"

  @spec function_description(String.t(), map()) :: String.t()
  defp function_description(suffix, %{name: "all", arity: arity}) do
    suffix = Inflex.pluralize(suffix)
    "all_#{suffix}/#{arity}"
  end

  defp function_description(suffix, %{name: name, arity: arity, errorable: true}),
    do: "#{name}_#{suffix}!/#{arity}"

  defp function_description(suffix, %{name: name, arity: arity}),
    do: "#{name}_#{suffix}/#{arity}"
end
