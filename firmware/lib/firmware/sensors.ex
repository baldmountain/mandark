defmodule Firmware.Sensors do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:check_sensors, state) do
    state =
      state
      |> check_temperature()

    {:noreply, state}
  end

  @impl true
  def handle_call(:get_sensor_data, _from, state) do
    {:ok, state, state}
  end

  defp check_temperature(state) do
    Logger.info("Checking temperature")
    state
  end
end
