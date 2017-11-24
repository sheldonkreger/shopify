use Mix.Config

config :shopify, Shopify.Request.HttpClient,
  adapter: Shopify.Request.Hackney,
  http_opts: []

import_config "#{Mix.env}.exs"
