defmodule Queue do

  require Ecto.Query
  alias Queue.Repo
  alias Queue.Message

  def add() do
    {:error, "provide text message!"}
  end

  def add(text) when not is_binary(text) do
    {:error, "invalid format, must be a string!"}
  end

  def add(text)  do
    case create_message(text) do
      {:ok, _} ->
        {:ok, "new message added!"}
      {:error, changeset} ->
        errors = humanaze_errors(changeset)
        {:error, errors}
    end
  end

  def get() do
    case get_next_message() do
      nil ->
        {:ok, "there is no available message!"}
      %Message{} = message ->
        set_status_as_processing(message)
    end
  end

  def ack(message_id) do
    case get_message(message_id) do
      nil -> {:error, "message not found!"}
      message -> update_message(message, %{status: :ack})
    end
  end


  defp create_message(text) do
    %Message{}
    |> Message.changeset(%{text: text, priority: NaiveDateTime.utc_now()})
    |> Repo.insert()
  end

  defp get_next_message() do
    query = Ecto.Query.from m in Message,
      where: m.status in ["new", "reject"], # get only free messages
      order_by: [asc: m.priority],
      limit: 1
    Repo.one(query)
  end

  defp get_message(id) do
    Repo.get(Message, id)
  end

  defp set_status_as_processing(message) do
    update_message(message, %{status: :processing})
  end

  defp update_message(nil, _) do
    nil
  end
  defp update_message(%Message{} = message, attrs) do
    Message.changeset(message, attrs)
    |> Repo.update()
  end

  defp humanaze_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

end
