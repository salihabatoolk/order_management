defmodule OrderManagementWeb.PageController do
  use OrderManagementWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
