defmodule Shopify.AdminAPI.Resource do
  @moduledoc """
  Structure for the Admin API resource
  """

  defmacro __using__(_opts) do
    quote do
      import Shopify.AdminAPI.Param
      import Shopify.AdminAPI.Resource, only: [new: 1]
    end
  end


  @type t :: %__MODULE__{method: atom, path: binary, body: map, query: map}
  @type http_method :: :get | :post | :delete | :put | :patch

  @methods ~w(get post delete put patch)a

  defstruct [:method, :path, :body, :query]

  @spec new(params :: list) :: t
  def new(params \\ []), do: struct(__MODULE__, Map.new(params))

  @spec prepare(resource :: t) :: %{method: http_method, body: binary, path: binary}
  def prepare(resource = %__MODULE__{}) do
    %{
      method: get_method(resource),
      path: "/admin/" <> to_path(resource),
      body: encode_body(resource.body)
    }
  end

  @spec to_path(resource :: t) :: binary
  def to_path(%__MODULE__{path: path, query: query}) do
    to_string(%URI{path: path <> ".json", query: to_query(query)})
  end

  defp encode_body(body) when is_map(body) or is_list(body), do: Poison.encode!(body)
  defp encode_body(body) when is_binary(body), do: body
  defp encode_body(nil), do: ""

  defp get_method(%__MODULE__{method: method}) when method in @methods,
    do: method
  defp get_method(%__MODULE__{method: method}),
    do: raise "Resource method must be one of the #{@methods}, got: #{inspect method}"

  defp to_query(q) when is_list(q) or is_map(q), do: URI.encode_query(q)
  defp to_query(q) when is_binary(q), do: q
  defp to_query(_), do: nil
end
