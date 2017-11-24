defmodule Shopify.Request do
  alias Shopify.Config

  def request(method, url, body, headers, config) do
    config = get_adapter_and_opts(config)
    config.adapter.request(method, url, body, headers, config.http_opts)
  end

  defp get_adapter_and_opts(config) do
    adapter =
      config[:adapter]
      || Config.get(Shopify.Request.HttpClient, [])[:adapter]
      || Shopify.Request.Hackney
    http_opts =
      config[:http_opts]
      || Config.get(Shopify.Request.HttpClient, [])[:http_opts]
      || []
    %{adapter: adapter, http_opts: http_opts}
  end
end
