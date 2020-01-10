defmodule Firmware.StartupSupervisor do
  require Logger

  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_scheduler do
    Logger.info("Time synchronization finished. Starting perioodic task scheduler.")

    spec = %{id: Firmware.Scheduler, start: {Firmware.Scheduler, :start_link, []}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
