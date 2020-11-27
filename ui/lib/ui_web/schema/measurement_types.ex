defmodule UiWeb.Schema.MeasurementTypes do
  use Absinthe.Schema.Notation

  object :measurement do
    field(:timestamp, :datetime)
    field(:temperature, :float)
    field(:humidity, :float)
    field(:pressure, :float)
  end
end
