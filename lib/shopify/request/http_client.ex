defmodule Shopify.Request.HttpClient do
  @type method :: :get | :post | :put | :patch | :delete
  @callback request(method, url :: binary, body :: binary, headers :: [tuple], http_opts :: list)
    :: {:ok, map} | {:error, any}
end
