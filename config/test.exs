use Mix.Config

config :queue, Queue.Repo,[
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "queue_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
]
