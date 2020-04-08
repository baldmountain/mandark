defmodule UiWeb.Schema do
  use Absinthe.Schema

  alias UiWeb.Resolvers

  import_types(UiWeb.Schema.MeasurementTypes)

  query do
    @desc "Get all posts"
    field :users, list_of(:user) do
      resolve(&Resolvers.Content.list_users/3)
    end
  end
end
