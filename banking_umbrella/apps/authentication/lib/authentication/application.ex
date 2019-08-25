defmodule Authentication.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Authentication.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Authentication.Supervisor)
  end
end
