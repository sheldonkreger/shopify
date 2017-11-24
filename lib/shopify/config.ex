defmodule Shopify.Config do
  @moduledoc false
  @app_name :shopify

  @doc """
  Get value for specified key from application config or return default
  (nil by default).
  """
  def get(key, default \\ nil) do
    Application.get_env(@app_name, key, default)
  end

  @doc """
  Get value from options, in case of absence, try application config, otherwise
  return specified default (nil by default).
  """
  def from(opts, key, default \\ nil) when is_list(opts) and is_atom(key) do
    opts[key] || apply(__MODULE__, :get, [key, default])
  end
end
