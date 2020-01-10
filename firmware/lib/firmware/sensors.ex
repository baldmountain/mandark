defmodule Firmware.Sensors do
  require Logger

  use GenServer

  @base_dir "/sys/bus/w1/devices/"

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

  defp read_temp(sensor) do
    Logger.info("   #{@base_dir}#{sensor}")
    # sensor_data = File.read!("#{base_dir}#{sensor}/w1_slave")
    # Logger.debug("reading sensor: #{sensor}: #{sensor_data}")
    # {temp, _} = Regex.run(~r/t=(\d+)/, sensor_data)
    #   |> List.last
    #   |> Float.parse
    # Logger.debug "#{temp/1000} C"

    :ok
  end

  defp check_temperature(state) do
    Logger.info("Checking temperature")

    File.ls!(@base_dir)
    # |> Enum.filter(&(String.starts_with?(&1, "28-")))
    |> Enum.each(&read_temp(&1))

    state
  end
end
