defmodule PurrWeb.RoomLive do
  use PurrWeb, :live_view
  require Logger

  @impl true
  def mount(%{"room_id" => room_id}, _session, socket) do
    Logger.info(room_id)
    topic = "room:" <> room_id
    PurrWeb.Endpoint.subscribe(topic)
    {:ok,
      assign(
        socket,
        room_id: room_id,
        topic: topic,
        messages: [%{uuid: UUID.uuid4(), content: "Hi, there!"}],
        temporary_assigns: [messages: []]
    )}
  end

  @impl true
  def handle_event("submit_message", %{"message_form" => %{"message" => message}}, socket) do
    message_payload = %{uuid: UUID.uuid4(), content: message}
    PurrWeb.Endpoint.broadcast(socket.assigns.topic, "update-message", message_payload)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "update-message", payload: message_payload}, socket) do
    Logger.info(message_payload)
    {:noreply, assign(socket, messages: [message_payload])}
  end
end
