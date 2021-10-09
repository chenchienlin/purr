defmodule PurrWeb.RoomLive do
  use PurrWeb, :live_view
  require MessagePayload
  require UserMessage
  require SystemMessage
  require Logger

  @impl true
  def mount(%{"room_id" => room_id}, _session, socket) do

    topic = "room:" <> room_id
    username = MnemonicSlugs.generate_slug(2)

    PurrWeb.Endpoint.subscribe(topic)
    # Track an arbitrary process as a presence.
    # Same with track/3, except track any process by topic and key.
    PurrWeb.Presence.track(self(), topic, username, %{}) # self() means the current process
    {:ok,
      assign(
        socket,
        room_id: room_id,
        topic: topic,
        username: username,
        users: [],
        message: "",
        messages: [],
        temporary_assigns: [messages: []]
    )}
  end

  @impl true
  def handle_event("submit_message", %{"message_form" => %{"message" => message}}, socket) do
    message_payload = %UserMessage{uuid: UUID.uuid4(), username: socket.assigns.username, content: message}
    PurrWeb.Endpoint.broadcast(socket.assigns.topic, "update_message", message_payload)
    {:noreply, assign(socket, message: "")}
  end

  @impl true
  def handle_event("update_form", %{"message_form" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  @impl true
  def handle_info(%{event: "update_message", payload: message_payload}, socket) do
    {:noreply, update(socket, :messages, fn messages -> update_message(messages, message_payload) end)}
  end

  defp update_message(messages, message_payload) when length(messages) < 15 do
      messages ++ [message_payload]
  end

  defp update_message(messages, message_payload) when length(messages) >= 15 do
    [ head | messages] = messages
    messages ++ [message_payload]
  end

  # "presence_diff" event. The diff structure will be a map of :joins and :leaves
  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    messages = system_message(%{"joins" => joins}) ++ system_message(%{"leaves" => leaves})
    users = PurrWeb.Presence.list(socket.assigns.topic) |> Map.keys()
    {:noreply, assign(socket, messages: messages, users: users)}
  end

  defp system_message(%{"joins" => joins}) do
    joins
    |> Map.keys()
    |> Enum.map(fn username -> %SystemMessage{uuid: UUID.uuid4(), content: "#{username} joined"} end)
  end

  defp system_message(%{"leaves" => leaves}) do
    leaves
    |> Map.keys()
    |> Enum.map(fn username -> %SystemMessage{uuid: UUID.uuid4(), content: "#{username} left"} end)
  end

  def render_message(%{type: :system, uuid: uuid, content: content}) do
    ~E"""
      <p id="<%= uuid %>"><em><%= content %></em></p>
    """
  end

  def render_message(%{type: :user, uuid: uuid, username: username, content: content}) do
    ~E"""
      <p id="<%= uuid %>"><strong><%= username%></strong>:  <%= content %></p>
    """
  end

  def render_user(user) do
    ~E"""
      <p> <%= user %> </p>
    """
  end
end
