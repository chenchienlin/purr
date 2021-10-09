defmodule PurrWeb.RoomLive do
  use PurrWeb, :live_view
  require MessagePayload
  require Logger

  @impl true
  def mount(%{"room_id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    username = MnemonicSlugs.generate_slug(2)
    message_payload = %MessagePayload{uuid: UUID.uuid4(), username: "room-master", content: "#{username} joined the chat!!!"}
    PurrWeb.Endpoint.subscribe(topic)
    {:ok,
      assign(
        socket,
        room_id: room_id,
        topic: topic,
        message: "",
        username: username,
        messages: [message_payload],
        temporary_assigns: [messages: []]
    )}
  end

  @impl true
  def handle_event("submit_message", %{"message_form" => %{"message" => message}}, socket) do
    message_payload = %MessagePayload{uuid: UUID.uuid4(), username: socket.assigns.username, content: message}
    PurrWeb.Endpoint.broadcast(socket.assigns.topic, "update-message", message_payload)
    {:noreply, assign(socket, message: "")}
  end

  def handle_event("update_form", %{"message_form" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  @impl true
  def handle_info(%{event: "update-message", payload: message_payload}, socket) do
    Logger.info(message_payload)
    {:noreply, assign(socket, messages: [message_payload])}
  end

end
