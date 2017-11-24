defmodule Shopify do
  @moduledoc false

  alias Shopify.{
    AdminAPI,
    Utils,
    Request
  }

  # TODO add simple and configurable retrying functionality

  def request(resource = %AdminAPI.Resource{}, shop_url, user, headers \\ [], config \\ []) do
    params = AdminAPI.Resource.prepare(resource)
    url = url(shop_url, params.path)
    headers = headers(user, headers)
    case Request.request(params.method, url, params.body, headers, config) do
      {:ok, resp = %{status_code: code, body: body}} when code in 200..299 ->
        {:ok, %{resp | body: Poison.decode!(body)}}
      {:ok, resp = %{body: body}} ->
        {:error, %{resp | body: Poison.decode!(body)}}
      {:error, reason} ->
        {:http_error, reason}
    end
  end

  defp url(url, path), do: Utils.shop_url(url) <> path

  # FIXME function below should be concern of AdminAPI context 
  defp headers(shop, headers),
    do: [auth_header(shop), {"accept", "application/json"} | headers]

  defp auth_header(user),
    do: {"X-Shopify-Access-Token", AdminAPI.Token.extract(user)}
end
