defmodule UiWeb.PageView do
  require Logger

  use UiWeb, :view

  def get_measurements() do
    try do
      vals = GenServer.call(Firmware.Sensors, :get_sensor_data)
      %{
        temperature: vals.temperature * 9.0 / 5.0 + 32.0,
        humidity: vals.humidity,
        preasure: vals.pressure * 10.0
      }
    catch
      _e, _v ->
        %{
          temperature: 0.0,
          humidity: 0.0,
          preasure: 0.0
        }
    end
  end
end
