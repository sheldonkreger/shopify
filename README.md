# Shopify (admin) api client

## Usage

* Create an authorization url

```
iex> shop = "https://myshop.myshopify.com"
iex> params = [client_id: <id>, client_secret: <secret>, redirect_uri: <uri>, scope: <scope>]
iex> Shopify.Oauth.authorization_url(shop, params)
```
* Once you've recieved a request to your `<uri>`, you can verify it with helper functions from `Shopify.Auth` module, and then extract `code` which is required for obtaining `Token`

* Get token
```
iex> {:ok, client} = Shopify.Oauth.get_access_token(shop, Keyword.put(params, :code, <code from request>))
```

* Make api requests
```
Shopify.AdminAPI.Order.list |> Shopify.request(shop, client)
```


