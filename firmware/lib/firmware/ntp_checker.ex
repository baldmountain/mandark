defmodule Firmware.NtpChecker do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    Process.send(self(), :check_ntp, [:noconnect])
    {:ok, state}
  end

  @impl true
  def handle_info(:check_ntp, state) do
    check()
    {:noreply, state}
  end

  defp check do
    case NervesTime.synchronized?() do
      true ->
        Firmware.StartupSupervisor.start_scheduler()
      _ ->
        Process.sleep(3000)
        Process.send(self(), :check_ntp, [:noconnect])
    end
  end
end
