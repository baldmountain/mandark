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

  @impl true
  def handle_info(:start_scheduler, state) do
    Firmware.StartupSupervisor.start_scheduler()
    {:noreply, state}
  end

  defp check do
    RingLogger.next()

    case NervesTime.synchronized?() do
      true ->
        IO.puts("yes #{Timex.now("America/New_York") |> Timex.format!("%m/%d/%Y %I:%M%P", :strftime)}")
        Process.send_after(self(), :start_scheduler, 3000)

      _ ->
        Process.sleep(5000)
        IO.puts("no #{Timex.now("America/New_York") |> Timex.format!("%m/%d/%Y %I:%M%P", :strftime)}")
        Process.send(self(), :check_ntp, [:noconnect])
    end
  end
end
