use Mix.Config

config :shopify, Shopify,
  base_url: "{shop}.myshopify.com",
  scope: "read_orders,read_fulfillments,read_analytics,read_shipping"

config :shopify, Shopify.Request.HttpClient,
  adapter: Shopify.Request.Hackney,
  http_opts: []

import_config "#{Mix.env}.exs"
