defmodule Shopify.Mixfile do
  use Mix.Project

  def project do
    [
      app: :shopify,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:oauth2, "~> 0.9"},
      {:poison, "~> 3.1", override: true},
      {:hackney, "1.6.6 or 1.7.1 or 1.8.6 or ~> 1.9", optional: true},
      {:inflex, "~> 1.8.1"}
    ]
  end
end
