defmodule Shopify.Oauth do
  @behaviour OAuth2.Strategy

  use OAuth2.Strategy
  alias Shopify.Config

  def client(shop_url, opts \\ []) when is_binary(shop) do
    url = shop_url <> "/admin"
    client_id = Config.from(opts, :client_id)
    client_secret = Config.from(opts, :client_secret)
    redirect_uri = Config.from(opts, :redirect_uri)
    per_user? = opts[:per_user] || opts[:online_access_mode]

    client =
      OAuth2.Client.new([
        strategy: __MODULE__,
        client_id: client_id,
        client_secret: client_secret,
        redirect_uri: redirect_uri,
        site: url,
        authorize_url: "#{url}/oauth/authorize",
        token_url: "#{url}/oauth/access_token",
      ])

    if per_user?, do: %{client | params: online_access_mode_params()}, else: client
  end

  def authorization_url(shop, opts \\ [])
  def authorization_url(shop, opts) when is_binary(shop) do
    client(shop, opts)
    |> put_param(:scope, Config.from(opts, :scope))
    |> OAuth2.Client.authorize_url!
  end
  def authorization_url(client = %OAuth2.Client{}, opts) do
    client
    |> put_param(:scope, Config.from(opts, :scope))
    |> OAuth2.Client.authorize_url!
  end

  def get_access_token(shop, opts \\ [])
  def get_access_token(shop, opts) when is_binary(shop) do
    client(shop, opts)
    |> put_param(:client_secret, Config.from(opts, :client_secret))
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

  defp online_access_mode_params, do: %{"grant_options[]" => "per-user"}
end
