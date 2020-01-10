defmodule Firmware.Heartbeat do
  require Logger

  def perform() do
    s = Timex.now("America/New_York") |> Timex.format!("%FT%T%:z", :strftime)
    Logger.info("<<<<< Heartbeat >>>>> - `#{s}`")
    GenServer.cast(Firmware.Sensors, :check_sensors)

    GenServer.call(Firmware.Sensors, :get_sensor_data)
    |> IO.inspect(label: "sensor values")

    RingLogger.next()
    :ok
  end
end
