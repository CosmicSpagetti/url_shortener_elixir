defmodule UrlShortenerElixir.Repo.Migrations.UpdateUrlsTable do
  use Ecto.Migration

  def change do
    create unique_index(:urls, :short_url )
  end
end
