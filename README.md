## Queue

**The persistent message queue on Elixir**

### Get running
1. `git clone git@github.com:Merff/Queue.git queue`
2. `cd queue`
3. `mix deps.get`
4. Set db credentials in `dev.exs` and `test.exs`
5. `MIX_ENV=test mix ecto.create`
6. `MIX_ENV=test mix ecto.migrate`
7. Now you can run: `mix test`

For run in console add:
`mix ecto.create`
`mix ecto.migrate`
run `iex -S mix` for try API features:

1. `Queue.add("my awesome message")` - for add new message
  -> `{:ok, "new message added!"}`
2. `Queue.get()` - for get next message in queue
  -> `{:ok, %Queue.Message{ id: 1, status: :processing, text: "my awesome message"} }`
3. `Queue.ack(1)` - for set message as ack, message_id as argument
  -> `{:ok, %Queue.Message{ id: 1, status: :ack,text: "my awesome message"} }`
3. `Queue.reject(1)` - for set message as reject, message_id as argument
  -> `{:ok, %Queue.Message{ id: 1, status: :reject: "my awesome message"} }`
