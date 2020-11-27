defmodule UiWeb.Schema do
  use Absinthe.Schema
  alias UiWeb.Resolvers

  import_types Absinthe.Type.Custom
  import_types UiWeb.Schema.MeasurementTypes

  query do
    @desc "Get all measurements"
    field :measurements, list_of(:measurement) do
      resolve(&Resolvers.Content.measurements/3)
    end
  end
end
