defmodule UiWeb.Schema.MeasurementTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :name, :string
  end
end
