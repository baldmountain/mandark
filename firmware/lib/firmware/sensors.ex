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
    name = "#{@base_dir}#{sensor}"
    Logger.info("   #{name}")
    case File.dir?(name) do
      true ->
        Logger.info("        #{inspect(File.ls!(name))}")
        try do
          sensor_data = File.read!("#{@base_dir}#{sensor}/w1_master_slave_count")
          Logger.info("reading w1_master_slave_count: #{sensor}: #{sensor_data}")
          sensor_data = File.read!("#{@base_dir}#{sensor}/w1_master_slaves")
          Logger.info("reading w1_master_slaves: #{sensor}: #{sensor_data}")
        catch
          e, v -> Logger.info("error: #{inspect(e)} value: #{inspect(v)}")
          x -> Logger.info("error: #{inspect(x)}")
        end
      _ ->
        case sensor do
          "w1_master_slave_count" ->
            Logger.info("w1_master_slave_count: #{File.read!(name)}")
          "w1_master_slaves" ->
            Logger.info("w1_master_slaves: #{File.read!(name)}")
          _ ->
            :ok
        end
    end
    # sensor_data = File.read!("#{base_dir}#{sensor}/w1_slave")
    # Logger.info("reading sensor: #{sensor}: #{sensor_data}")
    # {temp, _} = Regex.run(~r/t=(\d+)/, sensor_data)
    #   |> List.last
    #   |> Float.parse
    # Logger.info "#{temp/1000} C"

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
