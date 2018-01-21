defprotocol Shopify.AdminAPI.Credentials do
  @spec extract(any) :: %{url: binary, token: binary}
  def extract(arg)
end

defimpl Shopify.AdminAPI.Credentials, for: Map do
  def extract(c = %{url: _, token: _}), do: c
end

defimpl Shopify.AdminAPI.Credentials, for: OAuth2.Client do
  # TODO what if someone passes a client that does not have access token
  def extract(%OAuth2.Client{site: site, token: token}),
    do: %{url: site, token: token.access_token}
end
