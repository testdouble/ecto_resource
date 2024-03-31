defmodule EctoCooler.OptionParserTest do
  use ExUnit.Case

  alias EctoCooler.OptionParser

  describe "parse/1" do
    test "when given the an empty list" do
      assert OptionParser.parse("suffix", []) == %{
               all: %{
                 name: :all_suffixes,
                 description: "all_suffixes/1"
               },
               change: %{
                 name: :change_suffix,
                 description: "change_suffix/1"
               },
               changeset: %{
                 name: :suffix_changeset,
                 description: "suffix_changeset/0"
               },
               create: %{
                 name: :create_suffix,
                 description: "create_suffix/1"
               },
               create!: %{
                 name: :create_suffix!,
                 description: "create_suffix!/1"
               },
               delete: %{
                 name: :delete_suffix,
                 description: "delete_suffix/1"
               },
               delete!: %{
                 name: :delete_suffix!,
                 description: "delete_suffix!/1"
               },
               get: %{
                 name: :get_suffix,
                 description: "get_suffix/2"
               },
               get!: %{
                 name: :get_suffix!,
                 description: "get_suffix!/2"
               },
               get_by: %{
                 name: :get_suffix_by,
                 description: "get_suffix_by/2"
               },
               get_by!: %{
                 name: :get_suffix_by!,
                 description: "get_suffix_by!/2"
               },
               update: %{
                 name: :update_suffix,
                 description: "update_suffix/2"
               },
               update!: %{
                 name: :update_suffix!,
                 description: "update_suffix!/2"
               }
             }
    end

    test "when given the only atom and list of operations" do
      assert OptionParser.parse("suffix", only: [:create, :update]) == %{
               create: %{
                 name: :create_suffix,
                 description: "create_suffix/1"
               },
               update: %{
                 name: :update_suffix,
                 description: "update_suffix/2"
               }
             }
    end

    test "when given the except atom and list of operations" do
      assert OptionParser.parse("suffix", except: [:create, :delete!]) == %{
               all: %{
                 name: :all_suffixes,
                 description: "all_suffixes/1"
               },
               create!: %{
                 name: :create_suffix!,
                 description: "create_suffix!/1"
               },
               change: %{
                 name: :change_suffix,
                 description: "change_suffix/1"
               },
               changeset: %{
                 name: :suffix_changeset,
                 description: "suffix_changeset/0"
               },
               delete: %{
                 name: :delete_suffix,
                 description: "delete_suffix/1"
               },
               get: %{
                 name: :get_suffix,
                 description: "get_suffix/2"
               },
               get!: %{
                 name: :get_suffix!,
                 description: "get_suffix!/2"
               },
               get_by: %{
                 name: :get_suffix_by,
                 description: "get_suffix_by/2"
               },
               get_by!: %{
                 name: :get_suffix_by!,
                 description: "get_suffix_by!/2"
               },
               update: %{
                 name: :update_suffix,
                 description: "update_suffix/2"
               },
               update!: %{
                 name: :update_suffix!,
                 description: "update_suffix!/2"
               }
             }
    end

    test "when given :read" do
      assert OptionParser.parse("suffix", :read) == %{
               all: %{
                 name: :all_suffixes,
                 description: "all_suffixes/1"
               },
               get: %{
                 name: :get_suffix,
                 description: "get_suffix/2"
               },
               get!: %{
                 name: :get_suffix!,
                 description: "get_suffix!/2"
               },
               get_by: %{
                 name: :get_suffix_by,
                 description: "get_suffix_by/2"
               },
               get_by!: %{
                 name: :get_suffix_by!,
                 description: "get_suffix_by!/2"
               }
             }
    end

    test "when given :read_write" do
      assert OptionParser.parse("suffix", :read_write) == %{
               all: %{
                 name: :all_suffixes,
                 description: "all_suffixes/1"
               },
               get: %{
                 name: :get_suffix,
                 description: "get_suffix/2"
               },
               get!: %{
                 name: :get_suffix!,
                 description: "get_suffix!/2"
               },
               get_by: %{
                 name: :get_suffix_by,
                 description: "get_suffix_by/2"
               },
               get_by!: %{
                 name: :get_suffix_by!,
                 description: "get_suffix_by!/2"
               },
               change: %{
                 name: :change_suffix,
                 description: "change_suffix/1"
               },
               changeset: %{
                 name: :suffix_changeset,
                 description: "suffix_changeset/0"
               },
               create: %{
                 name: :create_suffix,
                 description: "create_suffix/1"
               },
               create!: %{
                 name: :create_suffix!,
                 description: "create_suffix!/1"
               },
               update: %{
                 name: :update_suffix,
                 description: "update_suffix/2"
               },
               update!: %{
                 name: :update_suffix!,
                 description: "update_suffix!/2"
               }
             }
    end

    test "when given the except atom and a list of bang functions" do
      assert OptionParser.parse("suffix", except: [:create!, :delete!, :get!, :update!]) == %{
               all: %{
                 name: :all_suffixes,
                 description: "all_suffixes/1"
               },
               change: %{
                 name: :change_suffix,
                 description: "change_suffix/1"
               },
               changeset: %{
                 name: :suffix_changeset,
                 description: "suffix_changeset/0"
               },
               create: %{
                 name: :create_suffix,
                 description: "create_suffix/1"
               },
               delete: %{
                 name: :delete_suffix,
                 description: "delete_suffix/1"
               },
               get: %{
                 name: :get_suffix,
                 description: "get_suffix/2"
               },
               get_by: %{
                 name: :get_suffix_by,
                 description: "get_suffix_by/2"
               },
               get_by!: %{
                 name: :get_suffix_by!,
                 description: "get_suffix_by!/2"
               },
               update: %{
                 name: :update_suffix,
                 description: "update_suffix/2"
               }
             }
    end

    test "when given the only atom and a list of bang functions" do
      assert OptionParser.parse("suffix", only: [:create!, :delete!, :get!, :update!]) == %{
               create!: %{
                 name: :create_suffix!,
                 description: "create_suffix!/1"
               },
               delete!: %{
                 name: :delete_suffix!,
                 description: "delete_suffix!/1"
               },
               get!: %{
                 name: :get_suffix!,
                 description: "get_suffix!/2"
               },
               update!: %{
                 name: :update_suffix!,
                 description: "update_suffix!/2"
               }
             }
    end

    test "when given suffix option and other options" do
      assert OptionParser.parse("", suffix: false, except: [:create!, :create]) == %{
               all: %{name: :all, description: "all/1"},
               change: %{name: :change, description: "change/1"},
               changeset: %{name: :changeset, description: "changeset/0"},
               delete: %{name: :delete, description: "delete/1"},
               get: %{name: :get, description: "get/2"},
               get_by: %{name: :get_by, description: "get_by/2"},
               get_by!: %{name: :get_by!, description: "get_by!/2"},
               update: %{name: :update, description: "update/2"},
               delete!: %{name: :delete!, description: "delete!/1"},
               get!: %{name: :get!, description: "get!/2"},
               update!: %{name: :update!, description: "update!/2"}
             }
    end
  end

  describe "create_suffix/2" do
    defmodule TestSchema do
    end

    test "with no options, it returns an empty sstring" do
      assert OptionParser.create_suffix(TestSchema, []) == ""
    end

    test "with suffix false option, it returns an empty string" do
      assert OptionParser.create_suffix(TestSchema, suffix: false) == ""
    end

    test "with suffix false option and other options" do
      assert OptionParser.create_suffix(TestSchema, suffix: false, except: [:create!, :create]) ==
               ""
    end

    test "when suffix is true, it returns a suffix" do
      assert OptionParser.create_suffix(TestSchema, suffix: true) == "test_schema"
    end
  end
end
