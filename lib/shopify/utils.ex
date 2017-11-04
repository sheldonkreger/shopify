defmodule Shopify.Utils do
  @moduledoc false

  alias Shopify.Config

  def shop_url(url), do: normalize_url(url)
  def shop_url(shop, nil), do: shop_url(shop, Config.get(Shopify, :base_url, ""))
  def shop_url(shop, base_url) when is_binary(shop) and is_binary(base_url) do
    unless String.starts_with?(base_url, "{shop}") do
      raise "Base url have to start with \"{shop}\", got: #{inspect base_url}"
    end
    to_string(%URI{scheme: "https", host: String.replace(base_url, "{shop}", shop)})
  end

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
