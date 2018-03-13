defmodule AuctionWeb.GraphCase do
  @moduledoc ~S"""
  This module defines the test case to be used by
  tests that require running GraphQL queries and mutations.

  ## Example

      @tag document: \"\"\"
      query GetProduct($id: ID!) {
        product(id: $id) {
          uuid
          title
          description
        }
      }
      \"\"\"
      test "gets a single product", tags do
        data = execute_document(tags)[:data]
        # make assertions ...
      end
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      import Absinthe.Relay.Node

      defp execute_document(tags, opts \\ []) do
        tags = Map.merge(tags, Enum.into(opts, %{}))
        {schema, tags} = Map.pop(tags, :schema, AuctionWeb.Schema)
        {query, tags} = Map.pop(tags, :query)
        {context, tags} = Map.pop(tags, :context, %{})
        {variables, _tags} = Map.pop(tags, :variables, %{})

        Absinthe.run!(query, schema, context: context, variables: variables)
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(DB.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(DB.Repo, {:shared, self()})
    end

    :ok
  end
end
