defmodule PurrWeb.PageController do
  use PurrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
