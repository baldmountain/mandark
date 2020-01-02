defmodule Firmware.Heartbeat do
  require Logger

  def perform() do
    s = "here" # Timex.now("America/New_York") |> Timex.format!("%FT%T%:z", :strftime)
    IO.puts("<<<<< Heartbeat >>>>> - #{s}")
    Logger.info("<<<<< Heartbeat >>>>> - #{s}")
  end
end