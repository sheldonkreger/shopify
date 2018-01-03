# Shopify (admin) api client

## Installation

add `{:shopify, git: "git@github.com:sheldonkreger/shopify.git"}`
make sure that you have approprate config entries in your ~/.ssh/config
(on macos I had a problem cloning via git unless I had key in ssh-agent)

## Configuration

If you don't want to always pass `client_id, client_secret, uri, scope` to `Shopify.Oauth.authorization_url` and `Shopify.Oauth.get_access_token` you can put them in your applicaton config -

```
config :shopify,
  client_id: <id>,
  client_secret: <secret>,
  scope: <scope>,
  redirect_uri: <uri>
```

## Usage

* Create an authorization url

```
iex> shop = "https://myshop.myshopify.com" # or Shopify.shop_url("myshop")
iex> params = [client_id: <id>, client_secret: <secret>, redirect_uri: <uri>, scope: <scope>] 
# or empty if you have those in your app config
iex> Shopify.Oauth.authorization_url(shop, params)
```
* Once you've recieved a request to your `<redirect_uri>`, you can verify it with helper functions from `Shopify.Auth` module, and then extract `code` which is required for obtaining `Token`

* Get token
```
iex> {:ok, client} = Shopify.Oauth.get_access_token(shop, Keyword.put(params, :code, <code from request>))
```
or (if you set values in your app config)
```
iex> {:ok, client} = Shopify.Oauth.get_access_token(shop, code: <code from request>)
```

* Make api requests
```
Shopify.AdminAPI.Order.all |> Shopify.request(client)
```

* If you have kept only token string instead of `OAuth2.Client` struct, you can make requests as following

```
Shopify.AdminAPI.Order.all |> Shopify.request({shop_url, token})`
```


