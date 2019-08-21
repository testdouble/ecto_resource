defmodule Mix.Tasks.EctoResource.Resources do
  @moduledoc """
  Task to list the resources defined by `EctoResource` within a context module.

  ## Examples

      $ mix ecto_resource.resources MyApp.MyContext

      Within the context Account, the following resource functions have been generated:

      User using the repo Repo:
      - Accounts.all_users/1
      - Accounts.change_user/1
      - Accounts.create_user/1
      - Accounts.create_user!/1
      - Accounts.delete_user/1
      - Accounts.delete_user!/1
      - Accounts.get_user/2
      - Accounts.get_user!/2
      - Accounts.update_user/2
      - Accounts.update_user!/2
  """

  use Mix.Task
  require Logger

  @doc """
  Run the task to list the resources.

  ## Examples
      iex>
  """
  @spec run(list()) :: any()
  def run([]) do
    Logger.error("""

    This task must be called with a context that uses `EctoResource`

    $ mix ecto_resource.resources MyApp.MyContext
    """)
  end

  def run(contexts) do
    Mix.Task.run("compile", [])
    Enum.each(contexts, &print_context/1)
  end

  @spec print_context(module()) :: any()
  defp print_context(context) do
    context
    |> resources()
    |> Enum.each(fn {repo, resource, functions} ->
      Logger.info("""

      Within the context #{context}, the following resource functions have been generated:

      #{resource} using the repo #{repo}:
      #{format_functions(context, functions)}

      """)
    end)
  end

  @spec format_functions(module(), list()) :: list()
  defp format_functions(context, functions) do
    functions
    |> Enum.map(fn f -> "- #{context}.#{f}" end)
    |> Enum.join("\n")
  end

  @spec resources(module()) :: any()
  defp resources(context) do
    context_module = Module.concat([context])

    context_module.__resource__(:resources)
  end
end
