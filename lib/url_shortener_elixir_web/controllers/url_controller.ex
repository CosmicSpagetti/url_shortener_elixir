defmodule UrlShortenerElixirWeb.UrlController do
  use UrlShortenerElixirWeb, :controller

  alias UrlShortenerElixir.Link
  alias UrlShortenerElixir.Link.Url

  action_fallback UrlShortenerElixirWeb.FallbackController

  def index(conn, _params) do
    urls = Link.list_urls()
    render(conn, "index.json", urls: urls)
  end

  def create(conn, %{"url" => url_params}) do
    with {:ok, %Url{} = url} <- Link.create_url(url_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.url_path(conn, :show, url))
      |> render("show.json", url: url)
    end
  end

  def show(conn, %{"id" => id}) do
    url = Link.get_url!(id)
    render(conn, "show.json", url: url)
  end

  def update(conn, %{"id" => id, "url" => url_params}) do
    url = Link.get_url!(id)

    with {:ok, %Url{} = url} <- Link.update_url(url, url_params) do
      render(conn, "show.json", url: url)
    end
  end

  def delete(conn, %{"id" => id}) do
    url = Link.get_url!(id)

    with {:ok, %Url{}} <- Link.delete_url(url) do
      send_resp(conn, :no_content, "")
    end
  end

  def redirect_to_long_url(conn, %{"shorten_url" => shorten_url}) do
    url = LinkCache.Cache.fetch(shorten_url, fn -> Link.find_long_url(shorten_url) end)
    redirect(conn, external: url)
  end
end
