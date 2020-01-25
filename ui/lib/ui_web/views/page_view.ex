defmodule UiWeb.PageView do
  use UiWeb, :view

  def get_measurements() do
      vals = GenServer.call(Firmware.Sensors, :get_sensor_data)
      %{
        temperature: vals.temperature * 9.0 / 5.0 + 32.0,
        humidity: vals.humidity,
        preasure: vals.pressure * 7.50062
      }
  end
end
