defmodule PurrWeb.RoomLive do
  use PurrWeb, :live_view
  require Logger

  @impl true
  def mount(%{"room_id" => room_id}, _session, socket) do
    Logger.info(room_id)
    topic = "room:" <> room_id
    PurrWeb.Endpoint.subscribe(topic)
    {:ok, assign(socket, room_id: room_id, topic: topic, messages: ["Hi, there!"])}
  end

  @impl true
  def handle_event("submit_message", %{"message_form" => %{"message" => message}}, socket) do
    Logger.info(message)
    {:noreply, socket}
  end
end
