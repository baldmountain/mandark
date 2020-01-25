defmodule Firmware.Sensors do
  require Logger

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    IO.puts("Starting Bme280")
    try do
      case Bme280.start_link() do
        {:ok, bme280_pid} ->
          {:ok, Map.put(state, :bme280_pid, bme280_pid)}
        err ->
          Logger.error("Error starting Bme280 #{inspect(err)}")
          {:ok, state}
      end
    catch
      e, v ->
        IO.puts("Error: #{inspect(e)} value: #{inspect(v)}")
        {:ok, state}
    end
  end

  @impl true
  def handle_cast(:check_sensors, state) do
    try do
      state = check_temperature(state)
      Logger.info("Checksensor state: #{inspect(state)}")
      {:noreply, state}
    catch
      e, v ->
        IO.puts("Error: #{inspect(e)} value: #{inspect(v)}")
        {:noreply, state}
    end
  end

  @impl true
  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  defp check_temperature(state) do
    Logger.info("Checking temperature")

    measurement = Bme280.measure(state.bme280_pid)
    Logger.info("measurement: #{inspect(measurement)}")

    Map.merge(state, Map.from_struct(measurement))
  end
end
