defmodule RabbitElixir do
  use Application

  import Supervisor.Spec, warn: false

  ##########################
  #    APPLICATION API     #
  ##########################

  def start(_type, _args), do: Supervisor.start_link(children, options)

  defp children do
    [
      worker(RabbitElixir.Consumer, []),
    ]
  end

  defp options do
    [
      strategy: :one_for_one,
      name:     RabbitElixir.Supervisor
    ]
  end
end
