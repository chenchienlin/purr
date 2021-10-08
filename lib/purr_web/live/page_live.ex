defmodule PurrWeb.PageLive do
  use PurrWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  # @impl true
  # def handle_event("suggest", %{"q" => query}, socket) do
  #   {:noreply, assign(socket, results: search(query), query: query)}
  # end

  @impl true
  def handle_event("create-room", _, socket) do
    Logger.info("<200>")
    room_url = "/" <> MnemonicSlugs.generate_slug(4)
    {:noreply, push_redirect(socket, to: room_url)}
  end

end
