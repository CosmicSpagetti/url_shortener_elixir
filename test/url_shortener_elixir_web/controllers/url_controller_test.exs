require IEx
defmodule UrlShortenerElixirWeb.UrlControllerTest do
  use UrlShortenerElixirWeb.ConnCase

  alias UrlShortenerElixir.Link
  alias UrlShortenerElixir.Link.Url

  @create_attrs %{
    long_url: "http://crouton.net",
    short_url: "someshort_url"
  }
  @update_attrs %{
    long_url: "some updated long_url",
    short_url: "some updated short_url"
  }
  @invalid_attrs %{long_url: nil, short_url: nil}

  def fixture(:url) do
    {:ok, url} = Link.create_url(@create_attrs)
    url
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all urls", %{conn: conn} do
      conn = get(conn, Routes.url_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create url" do
    test "renders url when data is valid", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.url_path(conn, :show, id))

      assert %{
               "id" => id,
               "long_url" => "http://crouton.net",
               "short_url" => "someshort_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update url" do
    setup [:create_url]

    test "renders url when data is valid", %{conn: conn, url: %Url{id: id} = url} do
      conn = put(conn, Routes.url_path(conn, :update, url), url: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.url_path(conn, :show, id))

      assert %{
               "id" => id,
               "long_url" => "some updated long_url",
               "short_url" => "some updated short_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, url: url} do
      conn = put(conn, Routes.url_path(conn, :update, url), url: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete url" do
    setup [:create_url]

    test "deletes chosen url", %{conn: conn, url: url} do
      conn = delete(conn, Routes.url_path(conn, :delete, url))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.url_path(conn, :show, url))
      end
    end
  end

  describe "redirects" do
    setup [:create_url]

    test "short_url to long_url", %{conn: conn, url: url} do
      conn = get(conn, Routes.url_path(conn, :redirect_to_long_url, url.short_url))

      assert redirected_to(conn, 302) == url.long_url
    end
  end


  defp create_url(_) do
    url = fixture(:url)
    {:ok, url: url}
  end
end
