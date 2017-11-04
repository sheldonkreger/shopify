defmodule Shopify.Config do
  @app_name :shopify

  def get(module \\ nil, key, default \\ nil)
  def get(nil, key, default) do
    Application.get_env(@app_name, key, default)
  end
  def get(module, key, default) when is_atom(module) do
    Application.get_env(@app_name, module, [])
    |> Keyword.get(key, default)
  end
  def get(opts, key, config_args) when is_list(opts) and is_atom(key) do
    opts[key] || apply(__MODULE__, :get, config_args(config_args, key))
  end

  defp config_args([], key), do: [key]
  defp config_args([mod], key), do: [mod, key]
  defp config_args([mod, default], key), do: [mod, key, default]
end
