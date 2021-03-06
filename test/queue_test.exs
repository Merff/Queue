defmodule QueueTest do
  use ExUnit.Case

  alias Queue.{Repo, Message}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  @valid_attrs "my message"
  @invalid_attrs ""
  @invalid_format_attrs 07

  describe "add/1" do

    test "add message with valid attrs" do
      assert Queue.add(@valid_attrs) == {:ok, "new message added!"}
    end

    test "add message with invalid attrs" do
      assert Queue.add(@invalid_attrs) == {:error, %{text: ["can't be blank"]}}
    end

    test "add message without attrs" do
      assert Queue.add() == {:error, "provide text message!"}
    end

    test "add message with invalid format attrs" do
      assert Queue.add(@invalid_format_attrs) == {:error, "invalid format, must be a string!"}
    end

  end


  describe "get/0" do

    test "get next message and set status to :processing" do
      create_message(%{text: "my message", priority: NaiveDateTime.utc_now()})
      {:ok, message} = Queue.get()
      assert message.text == "my message"
      assert message.status == :processing
    end

    test "when no one message exist" do
      assert Queue.get() == {:ok, "there is no available message!"}
    end

    test "when no one message avalable" do
      create_message(%{text: "my message", status: :processing, priority: NaiveDateTime.utc_now()})
      assert Queue.get() == {:ok, "there is no available message!"}
    end

    test "messages sort by priority" do
      create_message(%{text: "my message_1", priority: ~N[2018-02-06 20:02:47]})
      create_message(%{text: "my message_2", priority: ~N[2018-01-06 20:02:47]})
      {:ok, message} = Queue.get()
      assert message.text == "my message_2"
    end

  end

  describe "ack/1" do

    test "set message status to :ack" do
      {:ok, message} = create_message(%{text: "my message", priority: NaiveDateTime.utc_now()})
      {:ok, updated_message} = Queue.ack(message.id)
      assert updated_message.status == :ack
    end

    test "when invalid message_id" do
      assert Queue.ack(@invalid_format_attrs) == {:error, "message not found!"}
    end

  end

  describe "reject/1" do

    test "set message status to :reject and update priority" do
      {:ok, message} = create_message(%{text: "my message", priority: NaiveDateTime.utc_now()})
      {:ok, updated_message} = Queue.reject(message.id)
      assert updated_message.status == :reject
      assert updated_message.priority > message.priority
    end

    test "when invalid message_id" do
      assert Queue.reject(@invalid_format_attrs) == {:error, "message not found!"}
    end

  end

  defp create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

end
