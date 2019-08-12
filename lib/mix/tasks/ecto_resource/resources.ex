defmodule Mix.Tasks.EctoResource.Resources do
  @moduledoc """
  Task to list the resources defined by `EctoResource` within a context module.

  $ mix ecto_resource.resources MyApp.MyContext
  """

  use Mix.Task
  require Logger

  @shortdoc "List generated resource functions for context"
  def run([]) do
    Logger.error("""

    This task must be called with a context that uses `EctoResource`

    $ mix engine.resources MyApp.MyContext

    """)
  end

  def run(contexts) do
    Mix.Task.run("compile", [])
    Enum.each(contexts, &print_context/1)
  end

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

  defp format_functions(context, functions) do
    functions
    |> Enum.map(fn f -> "- #{context}.#{f}" end)
    |> Enum.join("\n")
  end

  defp resources(context) do
    context_module = Module.concat([context])

    context_module.__resource__(:resources)
  end
end
