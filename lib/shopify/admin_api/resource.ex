defmodule Shopify.AdminAPI.Resource do
  @moduledoc """
  Structure for the Admin API resource
  """

  alias Shopify.AdminAPI.Resource

  for method <- ~w(get delete post put patch)a do
    def unquote(method)(path, other_params \\ []) do
      params = [method: unquote(method), path: path]
      args = Keyword.merge(params, other_params)
      apply(Resource, :new, [args])
    end
  end

  defmacro __using__(opts) do
    quote do
      alias Shopify.AdminAPI.Resource
      import Shopify.AdminAPI.Param
      require Shopify.AdminAPI.Resource.Verbs
      Shopify.AdminAPI.Resource.Verbs.generate(unquote(opts))
    end
  end

  defstruct [:name, :method, :path, :body, :query]

  @typep method :: Shopify.Request.HttpClient.http_method
  @type t :: %__MODULE__{
    name: binary,
    method: method,
    path: binary | list,
    body: binary,
    query: map,
  }

  @spec new(params :: list) :: t
  def new(params \\ []), do: struct(__MODULE__, params)

  @spec prepare(resource :: t) :: %{method: method, body: binary, path: binary} | no_return
  def prepare(resource = %__MODULE__{}) do
    Map.new(method: validate_method(resource.method),
            path: to_path(resource.path, resource.query),
            body: encode_body(resource.body))
  end

  defp to_path(path, query) when is_binary(path),
    do: make_path(String.trim(path, "/"), query)
  defp to_path(path, query) when is_list(path),
    do: make_path(Enum.join(path, "/"), query)

  defp encode_body(body) when is_map(body) or is_list(body), do: Poison.encode!(body)
  defp encode_body(body) when is_binary(body), do: body
  defp encode_body(nil), do: ""

  @methods ~w(get post delete put patch)a
  defp validate_method(method) when method in @methods, do: method
  defp validate_method(method),
    do: raise ArgumentError, "Resource method must be one of the #{@methods}, got: #{inspect method}"

  defp to_query(q) when is_list(q) or is_map(q), do: URI.encode_query(q)
  defp to_query(q) when is_binary(q), do: q
  defp to_query(_), do: nil

  defp make_path(path, query) do
    %URI{path: path <> ".json", query: to_query(query)}
    |> to_string()
    |> String.trim_trailing("?")
  end
end
