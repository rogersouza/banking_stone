use Mix.Config

# Configure your database
config :banking, Banking.Repo,
  username: "postgres",
  password: "postgres",
  database: "banking_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :authentication, Authentication.Repo,
  username: "postgres",
  password: "postgres",
  database: "banking_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :banking_web, BankingWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :authentication, Authentication.Guardian,
  issuer: "authentication",
  secret_key: "BleooKmS9xeLcE6wvTAE/2D1352bOy+q8LKNvuPexAAyH21GS+na7rKh/o72cQyc"