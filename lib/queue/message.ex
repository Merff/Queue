defmodule Queue.Message do
  use Ecto.Schema

  schema "messages" do
    field :text, :string
    field :status, StatusEnum, default: 0
    field :priority, :utc_datetime
  end
end
