defmodule UrlShortenerElixir.Repo do
  use Ecto.Repo,
    otp_app: :url_shortener_elixir,
    adapter: Ecto.Adapters.Postgres
end
