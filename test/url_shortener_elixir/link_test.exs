defmodule UrlShortenerElixir.LinkTest do
  use UrlShortenerElixir.DataCase

  alias UrlShortenerElixir.Link

  describe "urls" do
    alias UrlShortenerElixir.Link.Url

    @valid_attrs %{long_url: "some long_url", short_url: "some short_url"}
    @update_attrs %{long_url: "some updated long_url", short_url: "some updated short_url"}
    @invalid_attrs %{long_url: nil, short_url: nil}

    def url_fixture(attrs \\ %{}) do
      {:ok, url} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Link.create_url()

      url
    end

    test "list_urls/0 returns all urls" do
      url = url_fixture()
      assert Link.list_urls() == [url]
    end

    test "get_url!/1 returns the url with given id" do
      url = url_fixture()
      assert Link.get_url!(url.id) == url
    end

    test "create_url/1 with valid data creates a url" do
      assert {:ok, %Url{} = url} = Link.create_url(@valid_attrs)
      assert url.long_url == "some long_url"
      assert url.short_url == "some short_url"
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Link.create_url(@invalid_attrs)
    end

    test "update_url/2 with valid data updates the url" do
      url = url_fixture()
      assert {:ok, %Url{} = url} = Link.update_url(url, @update_attrs)
      assert url.long_url == "some updated long_url"
      assert url.short_url == "some updated short_url"
    end

    test "update_url/2 with invalid data returns error changeset" do
      url = url_fixture()
      assert {:error, %Ecto.Changeset{}} = Link.update_url(url, @invalid_attrs)
      assert url == Link.get_url!(url.id)
    end

    test "delete_url/1 deletes the url" do
      url = url_fixture()
      assert {:ok, %Url{}} = Link.delete_url(url)
      assert_raise Ecto.NoResultsError, fn -> Link.get_url!(url.id) end
    end

    test "change_url/1 returns a url changeset" do
      url = url_fixture()
      assert %Ecto.Changeset{} = Link.change_url(url)
    end

    test "testing unique constraint on long url" do
      assert {:ok, %Url{} = url} = Link.create_url(@valid_attrs)
      assert url.long_url == "some long_url"
      assert url.short_url == "some short_url"
      assert {:error, %Ecto.Changeset{}} = Link.create_url(@valid_attrs)
    end
  end
end
