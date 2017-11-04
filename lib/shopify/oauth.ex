defmodule Shopify.Oauth do
  @behaviour OAuth2.Strategy
  use OAuth2.Strategy
  alias Shopify.{Utils, Config}

  def client(shop, opts \\ []) do
    shop_url = Utils.shop_url(shop) <> "/admin"
    client_id = Config.get(opts, :client_id, [Shopify])
    client_secret = Config.get(opts, :client_secret, [Shopify])
    redirect_uri = Config.get(opts, :redirect_uri, [Shopify])

    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: client_id,
      client_secret: client_secret,
      redirect_uri: redirect_uri,
      site: shop_url,
      authorize_url: "#{shop_url}/oauth/authorize",
      token_url: "#{shop_url}/oauth/access_token"
    ])
  end

  def authorization_url(shop, opts \\ [])
  def authorization_url(shop, opts) when is_binary(shop) do
    scope = Config.get(opts, :scope, [Shopify])
    client(shop, opts)
    |> put_param(:scope, scope)
    |> OAuth2.Client.authorize_url!
  end
  def authorization_url(client = %OAuth2.Client{}, opts) do
    scope = Config.get(opts, :scope, [Shopify])
    client
    |> put_param(:scope, scope)
    |> OAuth2.Client.authorize_url!
  end

  def get_access_token(shop, opts \\ [])
  def get_access_token(shop, opts) when is_binary(shop) do
    client_secret = Config.get(opts, :client_secret, [Shopify])
    client(shop, opts)
    |> put_param(:client_secret, client_secret)
    |> put_param(:code, opts[:code])
    |> OAuth2.Client.get_token
  end
  def get_access_token(client = %OAuth2.Client{}, opts) do
    client
    |> put_param(:code, opts[:code])
    |> OAuth2.Client.get_token
  end

  
  @impl OAuth2.Strategy
  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  @impl OAuth2.Strategy
  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
