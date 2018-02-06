defmodule Queue.Message do
  use Ecto.Schema

  schema "messages" do
    field :text, :string
    field :status, :integer
    field :priority, :integer
  end
end
