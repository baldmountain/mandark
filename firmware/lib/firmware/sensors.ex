defmodule Firmware.Sensors do
  require Logger

  use GenServer
  use Timex

  defmodule TimeBasedMeasurment do
    defstruct temperature: 0.0, humidity: 0.0, pressure: 0.0, timestamp: nil

    def from_measurement(measurement) do
      {:ok, datetime} = DateTime.now("America/New_York")
      %TimeBasedMeasurment{
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
      # Logger.info("Checksensor state: #{inspect(state)}")
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

  defp check_temperature(state) do
    Logger.info("Checking temperature")

    measurement = Bme280.measure(state.bme280_pid)
    {:ok, datetime} = DateTime.now("America/New_York")
    later = Timex.subtract(datetime, Duration.from_hours(24))

    measurements =
      [TimeBasedMeasurment.from_measurement(measurement) | state.measurements]
      |> Enum.filter(fn m -> Timex.after?(m.timestamp, later) end)

    state
      |> Map.merge(Map.from_struct(measurement))
      |> Map.put(:measurements, measurements)
  end
end
