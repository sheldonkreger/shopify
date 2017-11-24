defmodule Shopify.Utils do
  @moduledoc false

  @doc false
  def normalize_url("http://" <> _ = url, _),  do: url
  def normalize_url("https://" <> _ = url, _), do: url
  def normalize_url(url, base_url) do
    if String.contains?(url, ".") do
      "https://" <> url
    else
      unless String.contains?(base_url, "{shop}") do
        raise "Base url have to contain placeholder \"{shop}\", got: #{inspect base_url}"
      end
      to_string(%URI{scheme: "https", host: String.replace(base_url, "{shop}", url)})
    end
  end
end
