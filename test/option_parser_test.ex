defmodule EctoResource.OptionParserTest do
  use ExUnit.Case

  alias EctoResource.OptionParser

  describe "parse/1" do
    test "when given the an empty list" do
      assert OptionParser.parse("suffix", []) == %{
               all: %{
                 name: :all_suffixes,
                 description: "all_suffixes/1",
                 resource: "suffixes"
               },
               change: %{
                 resource: "suffix",
                 name: :change_suffix,
                 description: "change_suffix/1"
               },
               create: %{
                 resource: "suffix",
                 name: :create_suffix,
                 description: "create_suffix/1"
               },
               create!: %{
                 resource: "suffix",
                 name: :create_suffix!,
                 description: "create_suffix!/1"
               },
               delete: %{
                 resource: "suffix",
                 name: :delete_suffix,
                 description: "delete_suffix/1"
               },
               delete!: %{
                 resource: "suffix",
                 name: :delete_suffix!,
                 description: "delete_suffix!/1"
               },
               get: %{
                 resource: "suffix",
                 name: :get_suffix,
                 description: "get_suffix/2"
               },
               get!: %{
                 resource: "suffix",
                 name: :get_suffix!,
                 description: "get_suffix!/2"
               },
               update: %{
                 resource: "suffix",
                 name: :update_suffix,
                 description: "update_suffix/2"
               },
               update!: %{
                 resource: "suffix",
                 name: :update_suffix!,
                 description: "update_suffix!/2"
               }
             }
    end

    test "when given the only atom and list of operations" do
      assert OptionParser.parse("suffix", only: [:create, :update]) == %{
               create: %{
                 resource: "suffix",
                 name: :create_suffix,
                 description: "create_suffix/1"
               },
               create!: %{
                 resource: "suffix",
                 name: :create_suffix!,
                 description: "create_suffix!/1"
               },
               update: %{
                 resource: "suffix",
                 name: :update_suffix,
                 description: "update_suffix/2"
               },
               update!: %{
                 resource: "suffix",
                 name: :update_suffix!,
                 description: "update_suffix!/2"
               }
             }
    end

    test "when given the except atom and list of operations" do
      assert OptionParser.parse("suffix", except: [:create, :delete]) == %{
               all: %{
                 resource: "suffixes",
                 name: :all_suffixes,
                 description: "all_suffixes/1"
               },
               change: %{
                 resource: "suffix",
                 name: :change_suffix,
                 description: "change_suffix/1"
               },
               get: %{
                 resource: "suffix",
                 name: :get_suffix,
                 description: "get_suffix/2"
               },
               get!: %{
                 resource: "suffix",
                 name: :get_suffix!,
                 description: "get_suffix!/2"
               },
               update: %{
                 resource: "suffix",
                 name: :update_suffix,
                 description: "update_suffix/2"
               },
               update!: %{
                 resource: "suffix",
                 name: :update_suffix!,
                 description: "update_suffix!/2"
               }
             }
    end

    test "when given :read" do
      assert OptionParser.parse("suffix", :read) == %{
               all: %{
                 resource: "suffixes",
                 name: :all_suffixes,
                 description: "all_suffixes/1"
               },
               get: %{
                 resource: "suffix",
                 name: :get_suffix,
                 description: "get_suffix/2"
               },
               get!: %{
                 resource: "suffix",
                 name: :get_suffix!,
                 description: "get_suffix!/2"
               }
             }
    end

    test "when given :write" do
      assert OptionParser.parse("suffix", :write) == %{
               change: %{
                 resource: "suffix",
                 name: :change_suffix,
                 description: "change_suffix/1"
               },
               create: %{
                 resource: "suffix",
                 name: :create_suffix,
                 description: "create_suffix/1"
               },
               create!: %{
                 resource: "suffix",
                 name: :create_suffix!,
                 description: "create_suffix!/1"
               },
               update: %{
                 resource: "suffix",
                 name: :update_suffix,
                 description: "update_suffix/2"
               },
               update!: %{
                 resource: "suffix",
                 name: :update_suffix!,
                 description: "update_suffix!/2"
               }
             }
    end

    test "when given :delete" do
      assert OptionParser.parse("suffix", :delete) == %{
               delete: %{
                 resource: "suffix",
                 name: :delete_suffix,
                 description: "delete_suffix/1"
               },
               delete!: %{
                 resource: "suffix",
                 name: :delete_suffix!,
                 description: "delete_suffix!/1"
               }
             }
    end

    test "when given the except atom and a list of bang functions" do
      assert OptionParser.parse("suffix", except: [:create!, :delete!, :get!, :update!]) == %{
               all: %{
                 resource: "suffixes",
                 name: :all_suffixes,
                 description: "all_suffixes/1"
               },
               change: %{
                 resource: "suffix",
                 name: :change_suffix,
                 description: "change_suffix/1"
               },
               create: %{
                 resource: "suffix",
                 name: :create_suffix,
                 description: "create_suffix/1"
               },
               delete: %{
                 resource: "suffix",
                 name: :delete_suffix,
                 description: "delete_suffix/1"
               },
               get: %{
                 resource: "suffix",
                 name: :get_suffix,
                 description: "get_suffix/2"
               },
               update: %{
                 resource: "suffix",
                 name: :update_suffix,
                 description: "update_suffix/2"
               }
             }
    end

    test "when given the only atom and a list of bang functions" do
      assert OptionParser.parse("suffix", only: [:create!, :delete!, :get!, :update!]) == %{
               create!: %{
                 resource: "suffix",
                 name: :create_suffix!,
                 description: "create_suffix!/1"
               },
               delete!: %{
                 resource: "suffix",
                 name: :delete_suffix!,
                 description: "delete_suffix!/1"
               },
               get!: %{
                 resource: "suffix",
                 name: :get_suffix!,
                 description: "get_suffix!/2"
               },
               update!: %{
                 resource: "suffix",
                 name: :update_suffix!,
                 description: "update_suffix!/2"
               }
             }
    end
  end
end
