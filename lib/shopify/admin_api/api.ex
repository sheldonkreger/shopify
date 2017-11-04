defmodule Shopify.AdminAPI do
  @moduledoc false

  defmodule Resource do
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
        path: to_path(resource),
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

  alias __MODULE__.Resource

  def request(resource, shop_url, user, headers \\ [], opts \\ []) do
    params = Resource.prepare(resource)
    url = url(shop_url, params.path)
    headers = headers(user, headers)
    adapter = opts[:http] || %{} # TODO
    case Shopify.Request.request(params.method, url, params.body, headers, adapter) do
      {:ok, resp = %{status_code: code, body: body}} when code in 200..299 ->
        {:ok, %{resp | body: Poison.decode!(body)}}
      {:ok, resp = %{body: body}} ->
        {:error, %{resp | body: Poison.decode!(body)}}
      {:error, reason} ->
        {:http_error, reason}
    end
  end

  defp headers(shop, headers),
    do: [auth_header(shop), {"accept", "application/json"} | headers]

  defp auth_header(user),
    do: {"X-Shopify-Access-Token", Shopify.AdminAPI.Token.extract(user)}

  defp url(url, path) do
    Shopify.Utils.shop_url(url) <> "/admin/" <> path
  end
end
