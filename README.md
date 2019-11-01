EctoResource
============

* [About](#about)
* [Features](#features)
* [Installation](#installation)
* [Usage](#usage)
  * [Basic usage](#basic-usage---generate-all-ectoresource-functions)
  * [Explicit usage](#explicit-usage---generate-only-given-functions)
  * [Exclusive usage](#exclusive-usage---generate-all-but-the-given-functions)
  * [Alias :read](#alias-read---generate-data-access-functions)
  * [Alias :read_write](#alias-read_write---generate-data-access-and-manipulation-functions-excluding-delete)
  * [Resource functions](#resource-functions)
* [Caveats](#caveats)
* [Contribution](#contribution)
  * [Bug reports](#bug_reports)
  * [Pull requests](#pull_requests)
* [License](#license)
* [Authors](#authors)

Eliminate boilerplate involved in defining basic CRUD functions in a Phoenix context or Elixir module.

About
-----
When using [Context modules](https://hexdocs.pm/phoenix/contexts.html) in a [Phoenix](https://phoenixframework.org/) application, there's a general need to define the standard CRUD functions for a given `Ecto.Schema`. Phoenix context generators will even do this automatically. Soon you will notice that there's quite a lot of code involved in CRUD access within your contexts.

This can become problematic for a few reasons:

* Boilerplate functions for CRUD access, for every `Ecto.Schema` referenced in that context, introduce more noise than signal. This can obscure the more interesting details of the context.
* These functions may tend to accumulate drift from the standard API by inviting edits for new use-cases, reducing the usefulness of naming conventions.
* The burden of locally testing wrapper functions, yields low value for the writing and maintainence investment.

In short, at best this code is redundant and at worst is a deviant entanglement of modified conventions. All of which amounts to a more-painful development experience. `EctoResource` was created to ease this pain.

Features
--------

### Generate CRUD functions for a given `Ecto.Repo` and `Ecto.Schema`

`EctoResource` can be used to generate CRUD functions for a given `Ecto.Repo` and `Ecto.Schema`. By default it will create every function needed to create, read, update, and delete the resouce. It includes the `!` version of each function (where relevant) that will raise an error instead of return a value.

### Allow customization of generated resources

You can optionally include or exclude specific functions to generate exactly the functions your context requires. There's also two handy aliases for generating read functions and read/write functions.

### Automatic pluralization

For methods that return a list of records, it seems natural to use a plural name. For example, take a function named `MyContext.all_schema`. While this works, it makes the grammar a bit awkward and distracts from the intent of the function. `EctoResource` uses `Inflex` when generating functions to create readable english function names automatically. For example, given the schema `Person`, a function named `all_people/1` is generated.

### Generate documentation for each generated function

Every function generated includes documentation so your application's documentation will include the generated functions with examples.

### Reflection metadata

A function is generated for each resource defined by `EctoResource` to list all the functions generated for each `Ecto.Repo` and `Ecto.Schema`. A mix task is included to provide easy access to this information.

### Supports any module

While `EctoResource` was designed for [Phoenix Contexts](https://hexdocs.pm/phoenix/contexts.html) in mind, It can be used in any Elixir module.

Installation
------------

This package is available in [Hex](https://hex.pm/), the package can be installed by adding ecto_resource to your list of dependencies in mix.exs:

```elixir
    def deps do
      [
        {:ecto_resource, "~> 1.1.0"}
      ]
    end
```

Usage
-----

### Basic usage - generate all `EctoResource` functions

```elixir
defmodule MyApp.MyContext do
  alias MyApp.Repo
  alias MyApp.Schema
  use EctoResource

  using_repo(Repo) do
    resource(Schema)
  end
end
```

This generates all the functions `EctoResource` has to offer:

* `MyContext.all_schemas/1`
* `MyContext.change_schema/1`
* `MyContext.create_schema/1`
* `MyContext.create_schema!/1`
* `MyContext.delete_schema/1`
* `MyContext.delete_schema!/1`
* `MyContext.get_schema/2`
* `MyContext.get_schema!/2`
* `MyContext.get_schema_by/2`
* `MyContext.get_schema_by!/2`
* `MyContext.update_schema/2`
* `MyContext.update_schema!/2`

### Explicit usage - generate only given functions

```elixir
defmodule MyApp.MyContext do
  alias MyApp.Repo
  alias MyApp.Schema
  use EctoResource

  using_repo(Repo) do
    resource(Schema, only: [:create, :delete!])
  end
end
```

This generates only the given functions:

* `MyContext.create_schema/1`
* `MyContext.delete_schema!/1`

### Exclusive usage - generate all but the given functions

```elixir
defmodule MyApp.MyContext do
  alias MyApp.Repo
  alias MyApp.Schema
  use EctoResource

  using_repo(Repo) do
    resource(Schema, except: [:create, :delete!])
  end
end
```

This generates all the functions excluding the given functions:

* `MyContext.all_schemas/1`
* `MyContext.change_schema/1`
* `MyContext.create_schema!/1`
* `MyContext.delete_schema/1`
* `MyContext.get_schema/2`
* `MyContext.get_schema_by/2`
* `MyContext.get_schema_by!/2`
* `MyContext.get_schema!/2`
* `MyContext.update_schema/2`
* `MyContext.update_schema!/2`

### Alias `:read` - generate data access functions

```elixir
defmodule MyApp.MyContext do
  alias MyApp.Repo
  alias MyApp.Schema
  use EctoResource

  using_repo(Repo) do
    resource(Schema, :read)
  end
end
```

This generates all the functions necessary for reading data:

* `MyContext.all_schemas/1`
* `MyContext.get_schema/2`
* `MyContext.get_schema!/2`

### Alias `:read_write` - generate data access and manipulation functions, excluding delete

```elixir
defmodule MyApp.MyContext do
  alias MyApp.Repo
  alias MyApp.Schema
  use EctoResource

  using_repo(Repo) do
    resource(Schema, :read_write)
  end
end
```

This generates all the functions except `delete_schema/1` and `delete_schema!/1`:

* `MyContext.all_schemas/1`
* `MyContext.change_schema/1`
* `MyContext.create_schema/1`
* `MyContext.create_schema!/1`
* `MyContext.get_schema/2`
* `MyContext.get_schema!/2`
* `MyContext.update_schema/2`
* `MyContext.update_schema!/2`

### Resource functions

The general idea of the generated resource functions is to abstract away the `Ecto.Repo` and `Ecto.Schema` parts of data access with `Ecto` and provide an API to the context that feels natural and clear to the caller.

The following examples will all assume a repo named `Repo` and a schema named `Person`.

#### all_people

Fetches a list of all %Person{} entries from the data store. _Note: `EctoResource` will pluralize this function name using `Inflex`_

```elixir
iex> all_people()
[%Person{id: 1}]

iex> all_people(preloads: [:address])
[%Person{id: 1, address: %Address{}}]

iex> all_people(order_by: [desc: :id])
[%Person{id: 2}, %Person{id: 1}]

iex> all_people(preloads: [:address], order_by: [desc: :id]))
[
  %Person{
    id: 2,
    address: %Address{}
  },
  %Person{
    id: 1,
    address: %Address{}
  }
]
```

#### change_person

Creates a `%Person{}` changeset.

```elixir
iex> change_person(%{name: "Example Person"})
#Ecto.Changeset<
  action: nil,
  changes: %{name: "Example Person"},
  errors: [],
  data: #Person<>,
  valid?: true
>
```

#### create_person

Inserts a `%Person{}` with the given attributes in the data store, returning an `:ok`/`:error` tuple.

```elixir
iex> create_person(%{name: "Example Person"})
{:ok, %Person{id: 123, name: "Example Person"}}

iex> create_person(%{invalid: "invalid"})
{:error, %Ecto.Changeset}
```

#### create_person!

Inserts a `%Person{}` with the given attributes in the data store, returning a `%Person{}` or raises `Ecto.InvalidChangesetError`.

```elixir
iex> create_person!(%{name: "Example Person"})
%Person{id: 123, name: "Example Person"}

iex> create_person!(%{invalid: "invalid"})
** (Ecto.InvalidChangesetError)
```

#### delete_person

Deletes a given `%Person{}` from the data store, returning an `:ok`/`:error` tuple.

```elixir
iex> delete_person(%Person{id: 1})
{:ok, %Person{id: 1}}

iex> delete_person(%Person{id: 999})
{:error, %Ecto.Changeset}
```

#### delete_person!

Deletes a given `%Person{}` from the data store, returning the deleted `%Person{}`, or raises `Ecto.StaleEntryError`.

```elixir
iex> delete_person!(%Person{id: 1})
%Person{id: 1}

iex> delete_person!(%Person{id: 999})
** (Ecto.StaleEntryError)
```

#### get_person

Fetches a single `%Person{}` from the data store where the primary key matches the given id, returns a `%Person{}` or `nil`.

```elixir
iex> get_person(1)
%Person{id: 1}

iex> get_person(999)
nil

iex> get_person(1, preloads: [:address])
%Person{
    id: 1,
    address: %Address{}
}
```

#### get_person!

Fetches a single `%Person{}` from the data store where the primary key matches the given id, returns a `%Person{}` or raises `Ecto.NoResultsError`.

```elixir
iex> get_person!(1)
%Person{id: 1}

iex> get_person!(999)
** (Ecto.NoResultsError)

iex> get_person!(1, preloads: [:address])
%Person{
    id: 1,
    address: %Address{}
}
```

#### get_person_by

Fetches a single `%Person{}` from the data store where the attributes match the
given values.

```elixir
iex> get_person_by(%{name: "Chuck Norris"})
%Person{name: "Chuck Norris"}

iex> get_person_by(%{name: "Doesn't Exist"})
nil
```

#### get_person_by!

Fetches a single `%Person{}` from the data store where the attributes match the
given values. Raises an `Ecto.NoResultsError` if the record does not exist

```elixir
iex> get_person_by!(%{name: "Chuck Norris"})
%Person{name: "Chuck Norris"}

iex> get_person_by!(%{name: "Doesn't Exist"})
** (Ecto.NoResultsError)
```

#### update_person

Updates a given %Person{} with the given attributes, returns an `:ok`/`:error` tuple.

```elixir
iex> update_person(%Person{id: 1}, %{name: "New Person"})
{:ok, %Person{id: 1, name: "New Person"}}

iex> update_person(%Person{id: 1}, %{invalid: "invalid"})
{:error, %Ecto.Changeset}
```

#### update_person!

Updates a given %Person{} with the given attributes, returns a %Person{} or raises `Ecto.InvalidChangesetError`.

```elixir
iex> update_person!(%Person{id: 1}, %{name: "New Person"})
%Person{id: 1, name: "New Person"}

iex> update_person!(%Person{id: 1}, %{invalid: "invalid"})
** (Ecto.InvalidChangesetError)
```

Caveats
-------
This is not meant to be used as a wrapper for all the Repo functions within a context. Not all callbacks defined in Ecto.Repo are generated. `EctoResource` should be used to help reduce boilerplate code and tests for general CRUD operations.

It may be the case that `EctoResource` needs to evolve and provide slightly more functionality/flexibility in the future. However, the general focus is reducing boilerplate code.

Contribution
------------

### Bug reports

If you discover any bugs, feel free to create an issue on [GitHub](https://github.com/daytonn/ecto_resource/issues). Please add as much information as possible to help in fixing the potential bug. You are also encouraged to help even more by forking and sending us a pull request.

[Issues on GitHub](https://github.com/daytonn/ecto_resource/issues)

### Pull requests

* Fork it (https://github.com/daytonn/ecto_resource/fork)
* Add upstream remote (`git remote add upstream git@github.com:daytonn/ecto_resource.git`)
* Make sure you're up-to-date with upstream master (`git pull upstream master`)
* Create your feature branch (`git checkout -b feature/fooBar`)
* Commit your changes (`git commit -am 'Add some fooBar'`)
* Push to the branch (`git push origin feature/fooBar`)
* Create a new Pull Request

### Nice to have features/improvements (:point_up::wink:)

* Ability to override pluralization
* Find functions (maybe?)


License
-------
[Apache 2.0](https://raw.githubusercontent.com/daytonn/ecto_resource/master/LICENSE.txt)
