defmodule Shopify.Auth do
  @moduledoc """
  Helper functions for generating nonce and verifying hmac
  """

  @spec gen_nonce(length :: non_neg_integer) :: binary
  def gen_nonce(length \\ 32) when is_integer(length) and length > 0 do
    :crypto.strong_rand_bytes(length)
    |> Base.encode16(case: :lower)
  end

  # TODO ensure that hostname does not does not contain characters
  # other than letters (a-z), numbers (0-9), dots, and hyphens.
  @valid_hostname "myshopify.com"
  def validate_hostname(hostname) when is_binary(hostname) do
    String.ends_with?(hostname, @valid_hostname)
  end

  @spec validate_oauth_hmac(%{"hmac": binary}, secret :: binary) :: boolean
  def validate_oauth_hmac(data, secret) when is_map(data) do
    {hmac, data} = Map.pop(data, "hmac")
    validate_oauth_hmac(hmac, data, secret)
  end

  @spec validate_oauth_hmac(hmac :: binary, data :: binary | map, secret :: binary)
    :: boolean
  def validate_oauth_hmac(hmac, data, secret) when is_map(data) do
    data = data |> URI.encode_query |> sort()
    validate_oauth_hmac(hmac, data, secret)
  end

  def validate_oauth_hmac(hmac, data, secret)
      when is_binary(hmac) and
      is_binary(data) and
      is_binary(secret) do
    computed = Base.encode16(:crypto.hmac(:sha256, secret, data), case: :lower)
    secure_compare(computed, hmac)
  end

  # TODO
  def validate_webhook_hmac(hmac, data, secret)

  # TODO constant time comparison
  defp secure_compare(arg1, arg2) when byte_size(arg1) != byte_size(arg2),
    do: false
  defp secure_compare(arg1, arg2) do
    a = String.to_charlist(arg1)
    b = String.to_charlist(arg2)
    total =
      Enum.reduce(Enum.zip(a, b), 0, fn {b1, b2}, total ->
        if b1 == b2 do
          total + 1
        else
          total
        end
      end)
    total == length(a)
  end

  defp sort(data) when is_binary(data) do
    data
    |> String.split("&")
    |> Enum.sort
    |> Enum.join("&")
  end
end
