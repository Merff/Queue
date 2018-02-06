defmodule Queue.Message do
  use Ecto.Schema

  schema "messages" do
    field :text, :string
    field :status, StatusEnum, default: 0
    field :priority, :utc_datetime
  end

  def changeset(message, params \\ %{}) do
    message
    |> Ecto.Changeset.cast(params, [:text, :status, :priority])
    |> Ecto.Changeset.validate_required([:text, :priority])
  end
end
