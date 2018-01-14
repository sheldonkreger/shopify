defmodule Shopify.Oauth do
  @behaviour OAuth2.Strategy

  use OAuth2.Strategy
  alias Shopify.Config

  def client(shop_url, opts \\ []) when is_binary(shop_url) do
    url = Shopify.shop_admin_url(shop_url)
    client_id = Config.from(opts, :client_id)
    client_secret = Config.from(opts, :client_secret)
    redirect_uri = Config.from(opts, :redirect_uri)
    scope = Config.from(opts, :scope, "")

    client =
      OAuth2.Client.new([
        strategy: __MODULE__,
        client_id: client_id,
        client_secret: client_secret,
        redirect_uri: redirect_uri,
        site: url,
        params: %{"scope" => scope},
        authorize_url: "#{url}/oauth/authorize",
        token_url: "#{url}/oauth/access_token",
      ])

    %{client | params: get_extra_params(opts, client.params)}
  end

  def authorization_url(shop, opts \\ [])
  def authorization_url(shop, opts) when is_binary(shop) do
    client(shop, opts)
    |> OAuth2.Client.authorize_url!
  end
  def authorization_url(client = %OAuth2.Client{}, _opts) do
    client
    |> OAuth2.Client.authorize_url!
  end

  def get_access_token(shop, opts \\ [])
  def get_access_token(shop, opts) when is_binary(shop) do
    client(shop, opts)
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

  defp get_extra_params(opts, params) do
    Enum.reduce(opts, params, fn
      {opt, _}, params when opt in ~w(per_user online_access_mode)a ->
        Map.put_new(params, "grant_options[]", "per-user")
      _, params ->
        params
    end)
  end
end
