defmodule EctoCooler.Templates.Repo do
  require EEx

  alias EctoCooler.Env

  EEx.function_from_file(
    :def,
    :generate,
    Path.expand("repo.eex", "lib/templates/repo"),
    [:assigns]
  )

  def create_context([repo_name | _]) do
    [suffix: suffix] = Env.get(:resources, suffix: false)

    app_name = Env.get(:app_name, "EctoCooler")

    assigns = %{
      app_name: app_name,
      repo_name: repo_name,
      schema_name: Inflex.singularize(repo_name),
      suffix: suffix,
      repo_namespace: Env.get(:repo_namespace, "Repo"),
      schema_namespace: Env.get(:schema_namespace, "Schema")
    }

    content = generate(assigns)

    app_directory = Inflex.underscore(app_name)
    repo_dir = Env.get(:repo_dir, "lib/#{app_directory}/repo")
    repo_filename = "#{Inflex.underscore(repo_name)}.ex"

    path = Path.expand(repo_dir)
    filepath = "#{path}/#{repo_filename}"

    File.mkdir_p!(path)
    File.write!(filepath, content)

    {:ok, filepath}
  end
end
