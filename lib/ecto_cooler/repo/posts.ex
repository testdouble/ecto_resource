defmodule EctoCooler.Repo.Posts do
  use EctoCooler

  import Ecto.Query, warn: false

  alias EctoCooler.Repo
  alias EctoCooler.Schema.Post

  using_repo(Repo) do
    resource(Post)
  end
end
