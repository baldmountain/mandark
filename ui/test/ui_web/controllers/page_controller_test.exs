defmodule UiWeb.PageControllerTest do
  use UiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to the grow room!"
  end
end
