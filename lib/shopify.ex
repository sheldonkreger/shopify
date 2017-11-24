defmodule Shopify do
  @moduledoc false

  alias Shopify.{
    AdminAPI,
    Utils,
    Request,
    Config
  }

  # TODO add simple and configurable retrying functionality
  def request(resource = %AdminAPI.Resource{}, shop_url, user, headers \\ [], config \\ []) do
    params = AdminAPI.Resource.prepare(resource)
    url = shop_url(shop_url) <> params.path
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

  @default_base_url "{shop}.myshopify.com"
  @doc """
  Normalizes url, otherwise uses base url, defaults to "{shop}.myshopify.com"
  and configurable in config.exs:

  config :shopify, base_url: "{shop}.example.com"

  ## Examples
    iex> Shopify.shop_url("myshop")
    "https://myshop.myshopify.com"
    iex> Shopify.shop_url("myshop", "{shop}.mydomain.com")
    "https://myshop.mydomain.com"
    iex> Shopify.shop_url("https://myshop.com")
    "https://myshop.com"
    iex> Shopify.shop_url("myshop.com")
    "https://myshop.com"
  """
  def shop_url(url, base_url \\ Config.get(:base_url, @default_base_url)),
    do: Utils.normalize_url(url, base_url)

  # FIXME function below should be concern of AdminAPI context
  defp headers(shop, headers),
    do: [auth_header(shop), {"accept", "application/json"} | headers]

  defp auth_header(user),
    do: {"X-Shopify-Access-Token", AdminAPI.Token.extract(user)}
end
