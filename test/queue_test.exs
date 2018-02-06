defmodule QueueTest do
  use ExUnit.Case
  doctest Queue

  alias Queue.Repo

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
    setup [:create_message]
    test "get next message" do
      assert {:ok, message_text, _} = Queue.get()
      assert message_text == "my message"
    end
  end

  defp create_message(_) do
    Queue.add(@valid_attrs)
  end
end
