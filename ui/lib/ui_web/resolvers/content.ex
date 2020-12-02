defmodule UiWeb.Resolvers.Content do
  def list_users(_parent, _args, _resolution) do
    {:ok, []}
  end

  def measurements(_parent, _args, _resolution) do
    sensor_data = GenServer.call(Firmware.Sensors, :get_sensor_data)
    {:ok, Enum.map(sensor_data.measurements, &Map.from_struct/1)}
    # {:ok, [%{
    #   timestamp: Timex.now("America/New_York"),
    #   temperature: 2.0,
    #   humidity: 3.0,
    # }, %{
    #   timestamp: Timex.now("America/New_York"),
    #   temperature: 3.1,
    #   humidity: 3.2,
    # }]}
  end
end
