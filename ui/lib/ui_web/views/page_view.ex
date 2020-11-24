defmodule UiWeb.PageView do
  require Logger

  use UiWeb, :view

  def get_current_measurement() do
    try do
      sensor_data = GenServer.call(Firmware.Sensors, :get_sensor_data)

      %{
        temperature: sensor_data.temperature * 9.0 / 5.0 + 32.0,
        humidity: sensor_data.humidity,
        preasure: sensor_data.pressure
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

  def get_json_measurments()do
    try do
      sensor_data = GenServer.call(Firmware.Sensors, :get_sensor_data)
      measurements = Enum.map(sensor_data.measurements, fn m ->
        m
        |> Map.from_struct()
        |> Map.put(:timestamp, Timex.format!(m.timestamp, "{ISO:Extended}"))
      end)
      Logger.info(">>> #{inspect(measurements)}")
      Jason.encode!(measurements)
    catch
      e, v ->
        Logger.error("error: #{inspect(e)} v: #{inspect(v)}")
        "[]"
    end
  end
end
