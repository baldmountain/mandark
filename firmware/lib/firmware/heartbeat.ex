defmodule Firmware.Heartbeat do
  require Logger

  def perform() do
    s = Timex.now("America/New_York") |> Timex.format!("%FT%T%:z", :strftime)
    Logger.info("<<<<< Heartbeat >>>>> - `#{s}`")

    try do
      GenServer.cast(Firmware.Sensors, :check_sensors)

      vals = GenServer.call(Firmware.Sensors, :get_sensor_data)
      Logger.info("<<<<<<< sensor values >>>>>>> #{inspect(vals)}")
    catch
      e, v ->
        Logger.error("Error: #{inspect(e)} value: #{inspect(v)}")
    end

    RingLogger.next()
    :ok
  end
end
