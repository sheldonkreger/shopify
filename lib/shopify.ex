defmodule Shopify do
  @moduledoc false

  alias Shopify.{
    AdminAPI,
    Utils,
    Request,
    Config,
  }

  @default_options [resource_only: true]

  @spec request(
    resource :: AdminAPI.Resource.t,
    client :: AdminAPI.Credentials.t,
    opts :: keyword,
    headers :: [tuple],
    config :: keyword) :: {:ok, data :: map}
                        | {:error, reason :: any}
                        | {:http_error, reason :: any}
                        | {:decoding_error, reason :: any}
  def request(resource = %AdminAPI.Resource{}, client, opts \\ [], headers \\ [], config \\ []) do
    req = AdminAPI.Resource.prepare(resource)
    opts = Keyword.merge(@default_options, opts)
    credentials = AdminAPI.Credentials.extract(client)
    headers = headers(credentials.token, headers)
    url = shop_admin_url(credentials.url) <> "/" <> req.path
    Request.request(req.method, url, req.body, headers, config) |> handle_response(resource.name, opts)
  end

  # TODO use same option for parsing error
  defp handle_response({:ok, resp = %{status_code: code}}, name, opts)
  when code in 200..299 do
    parse_body(resp, name, opts)
  end

  # when status code is not in 200..299 we treat it as an error
  defp handle_response({:ok, resp}, name, opts) do
    case parse_body(resp, name, opts) do
      {:ok, resp_or_body} ->
        {:error, resp_or_body}
      other ->
        other
    end
  end

  defp handle_response({:error, reason}, _opts, _name) do
    {:http_error, reason}
  end

  defp parse_body(resp, name, opts) do
    with \
      {:ok, body} <- Poison.decode(resp.body),
      resp_or_body <- apply_options(resp, body, name, opts) do
        {:ok, resp_or_body}
    else
      {:error, reason} ->
        {:decoding_error, reason}
      {:error, reason, _code} -> # mistake in documentation? 
        {:decoding_error, reason}
    end
  end

  defp apply_options(resp, body, name, opts) do
    cond do
      opts[:raw_response] ->
        resp
      opts[:resource_only] ->
        body[name] || body
      true ->
        resp
    end
  end

  @default_base_url "https://{shop}.myshopify.com"
  @doc """
  Normalizes url, otherwise uses base url, defaults to "https://{shop}.myshopify.com"
  and configurable in config.exs:

  config :shopify, base_url: "https://{shop}.example.com"

  ## Examples
    iex> Shopify.shop_url("myshop")
    "https://myshop.myshopify.com"

    iex> Shopify.shop_url("myshop.myshopify.com")
    "https://myshop.myshopify.com"

    iex> Shopify.shop_url("myshop", "https://{shop}.mydomain.com")
    "https://myshop.mydomain.com"

    iex> Shopify.shop_url("https://myshop.com")
    "https://myshop.com"
  """
  def shop_url(url, base_url \\ Config.get(:base_url, @default_base_url)),
    do: Utils.normalize_url(url, base_url)

  def shop_admin_url(url) do
    if String.ends_with?(url, "/admin") do
      url
    else
      url
      |> String.trim_trailing("/")
      |> shop_url()
      |> Kernel.<>("/admin")
    end
  end

  # FIXME function below should be concern of AdminAPI context
  defp headers(token, headers),
    do: [auth_header(token),
        {"accept", "application/json"},
        {"content-type", "application/json"} | headers]

  defp auth_header(token), do: {"X-Shopify-Access-Token", token}
end
