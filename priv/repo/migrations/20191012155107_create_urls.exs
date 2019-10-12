defmodule UrlShortenerElixir.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :short_url, :string
      add :long_url, :string

      timestamps()
    end

  end
end
