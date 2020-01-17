defmodule Firmware.Sensors do
  require Logger

  use GenServer

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
    {:reply, state, state}
  end


  defp check_temperature(state) do
    Logger.info("Checking temperature")

    measurement = Bme280.measure(Bme280)
    Logger.info("measurement: #{inspect(measurement)}")

    state
  end
end
