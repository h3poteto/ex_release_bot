defmodule ReleaseBot do

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ReleaseBot.Bot, [[]]),
    ]

    opts = [strategy: :one_for_one, name: ReleaseBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
