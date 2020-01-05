defmodule Firmware.StartupSupervisor do
  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_scheduler do
    spec = %{id: Firmware.Scheduler, start: {Firmware.Scheduler, :start_link, []}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
