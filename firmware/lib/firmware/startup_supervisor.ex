defmodule Firmware.StartupSupervisor do
  use DynamicSupervisor

  def start_link(_arg) do
    {:ok, pid} = DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    Process.start_after(pid, :start_scheduer, 3,000)
    {:ok, pid}
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def handle_call(:start_scheduer, state) do
    IO.puts("<<< call >>>")
    start_scheduer()
    {:ok, state}
  end

  def handle_cast(:start_scheduer, state) do
    IO.puts("<<< cast >>>")
    start_scheduer()
    {:ok, state}
  end

  def handle_cast(:check_ntp, state) do
    IO.puts("check_ntp >>> #{NervesTime.synchronized?()}")
    {:noreply, state}
  end

  def start_scheduer do
    spec = %{id: Firmware.Scheduler, start: {Firmware.Scheduler, :start_link, []}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
