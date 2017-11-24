defmodule Shopify.Request.HttpClient do
  @type http_method :: :get | :post | :put | :patch | :delete
  @callback request(http_method, url :: binary, body :: binary, headers :: [tuple], http_opts :: list)
    :: {:ok, map} | {:error, any}
end
