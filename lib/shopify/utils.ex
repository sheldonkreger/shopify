defmodule Shopify.Utils do
  @moduledoc false

  alias Shopify.Config

  @doc """
  Uses base url (default is "{shop}.myshopify.com" and configurable in config.exs)
  or provided, in form of "{shop}.localhost" to construct shop url
  ## Examples 
    iex> Shopify.Utils.shop_url("sysashi", nil)
    "https://sysashi.myshopify.com"
    iex> Shopify.Utils.shop_url("sysashi", "{shop}.mydomain.com")
    "https://sysashi.mydomain.com"
  """
  def shop_url(shop, nil), do: shop_url(shop, Config.get(Shopify, :base_url, ""))
  def shop_url(shop, base_url) when is_binary(shop) and is_binary(base_url) do
    unless String.starts_with?(base_url, "{shop}") do
      raise "Base url have to start with \"{shop}\", got: #{inspect base_url}"
    end
    to_string(%URI{scheme: "https", host: String.replace(base_url, "{shop}", shop)})
  end

  # argument to this function could be
  # in form of {http | https}://<host> or just <host>
  def shop_url(url), do: normalize_url(url)

  defp normalize_url("http://" <> _ = url),  do: url
  defp normalize_url("https://" <> _ = url), do: url
  defp normalize_url(url) do
    if String.contains?(url, ".") do
      "https://" <> url
    else
      shop_url(url, nil)
    end
  end
end
