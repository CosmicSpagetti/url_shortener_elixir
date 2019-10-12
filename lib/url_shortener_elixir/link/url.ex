defmodule UrlShortenerElixir.Link.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :long_url, :string
    field :short_url, :string

    timestamps()
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:short_url, :long_url])
    |> validate_required([:short_url, :long_url])
    |> unique_constraint(:short_url)
  end
end
