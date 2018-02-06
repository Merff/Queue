use Mix.Config

config :queue, Queue.Repo,[
  adapter: Ecto.Adapters.Postgres,
  database: "queue_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
]
