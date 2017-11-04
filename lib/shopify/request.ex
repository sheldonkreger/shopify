defmodule Shopify.Request do
  def request(method, url, body, headers, config) do
    default = Shopify.Request.HttpClient
    |> Shopify.Config.get
    |> Map.new
    config = Map.merge(default, config)
    http_opts = Map.get(config, :http_opts, [])
    config.adapter.request(method, url, body, headers, http_opts)
  end
end
