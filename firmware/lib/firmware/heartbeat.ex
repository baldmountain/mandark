defmodule Firmware.Heartbeat do
  require Logger

  def perform() do
    s = Timex.now("America/New_York") |> Timex.format!("%FT%T%:z", :strftime)
    Logger.info("<<<<< Heartbeat >>>>> - #{inspect(Timex.now("America/New_York"))} `#{s}` logger")
    RingLogger.next()
  end
end