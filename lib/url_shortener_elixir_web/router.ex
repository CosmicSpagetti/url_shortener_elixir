defmodule UrlShortenerElixirWeb.Router do
  use UrlShortenerElixirWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UrlShortenerElixirWeb do
    pipe_through :api
    resources "/urls", UrlController, except: [:new, :edit]
  end

  scope "/redirect", UrlShortenerElixirWeb do
    get "/:shorten_url", UrlController, :redirect_to_long_url
  end
end
