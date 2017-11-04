defprotocol Shopify.AdminAPI.Token do
  @fallback_to_any true

  @spec extract(any) :: binary
  def extract(arg)
end

defimpl Shopify.AdminAPI.Token, for: Any do
  def extract(arg), do: arg
end

defimpl Shopify.AdminAPI.Token, for: OAuth2.Client do
  def extract(client), do: client.token.access_token
end
