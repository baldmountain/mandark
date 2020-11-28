defmodule UiWeb.PageView do
  require Logger
  use Timex

  use UiWeb, :view

  defmodule TimeBasedMeasurement do
    defstruct temperature: 0.0, humidity: 0.0, timestamp: nil

    def from_measurement(measurement, add \\ 0)
    def from_measurement(measurement, add) do
      {:ok, datetime} = DateTime.now("Etc/UTC")

      case add do
        0 ->
          %TimeBasedMeasurement{
            temperature: measurement.temperature,
            humidity: measurement.humidity,
            timestamp: datetime
          }

        mins ->
          %TimeBasedMeasurement{
            temperature: measurement.temperature,
            humidity: measurement.humidity,
            timestamp: Timex.add(datetime, Duration.from_minutes(mins))
          }
      end
    end
  end

  defp get_sensor_data() do
    # GenServer.call(Firmware.Sensors, :get_sensor_data)
    %{
      temperature: 24.0,
      humidity: 38.5,
      measurements: [
        TimeBasedMeasurement.from_measurement(%{
          temperature: 24.0,
          humidity: 38.5
        }),
        TimeBasedMeasurement.from_measurement(%{
          temperature: 24.3,
          humidity: 38.5
        }, 3),
        TimeBasedMeasurement.from_measurement(%{
          temperature: 24.3,
          humidity: 38.5
        }, 6),
        TimeBasedMeasurement.from_measurement(%{
          temperature: 24.3,
          humidity: 38.5
        }, 9),
        TimeBasedMeasurement.from_measurement(%{
          temperature: 24.3,
          humidity: 38.5
        }, 12),
        TimeBasedMeasurement.from_measurement(%{
          temperature: 24.3,
          humidity: 38.5
        }, 15),
        TimeBasedMeasurement.from_measurement(%{
          temperature: 24.3,
          humidity: 38.5
        }, 18),
        TimeBasedMeasurement.from_measurement(%{
          temperature: 24.3,
          humidity: 38.5
        }, 21),
        TimeBasedMeasurement.from_measurement(%{
          temperature: 24.3,
          humidity: 38.5
        }, 24),
        TimeBasedMeasurement.from_measurement(%{
          temperature: 24.3,
          humidity: 38.5
        }, 27),
      ]
    }
  end

  def get_current_measurement() do
    try do
      sensor_data = get_sensor_data()
      %{
        temperature: sensor_data.temperature * 9.0 / 5.0 + 32.0,
        humidity: sensor_data.humidity
      }
    catch
      _e, _v ->
        %{
          temperature: 0.0,
          humidity: 0.0
        }
    end
  end

  def get_json_measurments() do
    try do
      sensor_data = get_sensor_data()

      measurements =
        Enum.map(sensor_data.measurements, fn m ->
          m
          |> Map.from_struct()
          |> Map.put(:timestamp, Timex.format!(m.timestamp, "{ISO:Extended}"))
        end)

      Jason.encode!(measurements)
    catch
      e, v ->
        Logger.error("error: #{inspect(e)} v: #{inspect(v)}")
        "[]"
    end
  end
end
