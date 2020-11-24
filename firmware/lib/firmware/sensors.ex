defmodule Firmware.Sensors do
  require Logger

  use GenServer
  use Timex

  defmodule TimeBasedMeasurement do
    defstruct temperature: 0.0, humidity: 0.0, pressure: 0.0, timestamp: nil

    def from_measurement(measurement) do
      {:ok, datetime} = DateTime.now("America/New_York")

      %TimeBasedMeasurement{
        temperature: measurement.temperature,
        humidity: measurement.humidity,
        pressure: measurement.pressure,
        timestamp: datetime
      }
    end
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    start_bme280(state)
  end

  @impl true
  def handle_cast(:check_sensors, state) do
    try do
      state = check_temperature(state)
      Logger.info("Checksensor state: #{inspect(state)}")
      {:noreply, state}
    catch
      e, v ->
        Logger.error("Error: #{inspect(e)} value: #{inspect(v)}")
        {:noreply, state}
    end
  end

  @impl true
  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  defp start_bme280(state) do
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

  defp restart_bme280(state) do
    state =
      case Map.get(state, :bme280_pid) do
        nil ->
          state

        pid ->
          GenServer.cast(pid, :stop)
          Map.delete(state, :bme280_pid)
      end

    case start_bme280(state) do
      {:ok, state} -> state
      _ -> state
    end
  end

  defp check_temperature(%{bme280_pid: bme280_pid} = state) do
    Logger.info("Checking temperature")

    case Bme280.measure(bme280_pid) do
      %{temperature: 0.0, presure: 0.0, humidity: 0.0} ->
        restart_bme280(state)

      measurement ->
        {:ok, datetime} = DateTime.now("America/New_York")
        later = Timex.subtract(datetime, Duration.from_hours(24))

        measurements =
          [TimeBasedMeasurement.from_measurement(measurement) | state.measurements]
          |> Enum.filter(fn m -> Timex.after?(m.timestamp, later) end)

        state
        |> Map.merge(Map.from_struct(measurement))
        |> Map.put(:measurements, measurements)
    end
  end

  defp check_temperature(state) do
    restart_bme280(state)
  end
end
