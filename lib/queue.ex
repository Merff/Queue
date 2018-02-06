defmodule Queue do

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


  defp create_message(text) do
    %Message{}
    |> Message.changeset(%{text: text, priority: NaiveDateTime.utc_now()})
    |> Queue.Repo.insert()
  end

  defp humanaze_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

end
