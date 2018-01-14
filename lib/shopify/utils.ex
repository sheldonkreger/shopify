defmodule Shopify.Utils do
  @moduledoc false

  @doc false
  def normalize_url("http://" <> _ = url, _),  do: url
  def normalize_url("https://" <> _ = url, _), do: url
  def normalize_url(url, base_url) do
    cond do
      String.contains?(url, ".") ->
        "https://" <> url
      valid_base_url?(base_url) ->
        String.replace(base_url, "{shop}", url, global: :false)
      true ->
        raise ArgumentError,
          "Base url have to contain placeholder '{shop}' and starts with a schema " <>
          "(http|https), got: #{inspect base_url}"
    end
  end

  @has_schema ~r/https?:\/\//
  defp valid_base_url?(base) do
    Regex.match?(@has_schema, base) and String.contains?(base, "{shop}")
  end
end
