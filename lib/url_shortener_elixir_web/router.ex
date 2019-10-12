defmodule UrlShortenerElixirWeb.Router do
  use UrlShortenerElixirWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UrlShortenerElixirWeb do
    pipe_through :api
  end
end
