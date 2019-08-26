# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :banking,
  ecto_repos: [Banking.Repo]

config :authentication,
  ecto_repos: [Authentication.Repo]

config :banking_web,
  ecto_repos: [Banking.Repo, Authentication.Repo],
  generators: [context_app: :banking]

# Configures the endpoint
config :banking_web, BankingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "THP1Vw5I5pp2iUkIwVOrb+2kREIRWTLBK2+XfyqFeBr/iKfopNaqYP/RuuH63b/G",
  render_errors: [view: BankingWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BankingWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :comeonin, :bcrypt_log_rounds, 4

config :money,
  default_currency: :BRL,
  separator: ".",
  delimiter: ","

config :banking,
  initial_balance: 1000

import_config "#{Mix.env()}.exs"
