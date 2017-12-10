defmodule Shopify do
  @moduledoc false

  alias Shopify.{
    AdminAPI,
    Utils,
    Request,
    Config
  }

  defp default_options, do: [resource_only: true]

  def request(resource = %AdminAPI.Resource{}, client = %OAuth2.Client{}, opts \\ [], headers \\ [], config \\ []) do
    params = AdminAPI.Resource.prepare(resource)
    url = client.site <> "/" <> params.path # TODO
    headers = headers(client, headers)
    opts = Keyword.merge(default_options(), opts)

    IO.inspect {params, url}
    Request.request(params.method, url, params.body, headers, config)
    |> handle_response(opts, resource.name)
  end


  # TODO use same option for parsing error
  defp handle_response({:ok, resp = %{status_code: code, body: body}}, opts, name)
  when code in 200..299 do
    cond do
      opts[:raw_response] ->
        {:ok, resp}
      opts[:resource_only] ->
        parse_body(body, name)
      true ->
        case parse_body(body, nil) do
          {:ok, body} ->
            {:ok, %{resp | body: body}}
          {:decoding_error, reason} ->
            {:decoding_error, reason, resp}
        end
    end
  end

  defp handle_response({:ok, resp = %{body: body}}, _opts, _name) do
    case parse_body(body, nil) do
      {:ok, body} ->
        {:error, %{resp | body: body}}
      {:decoding_error, _reason} ->
        {:error, resp}
    end
  end

  defp handle_response({:error, reason}, _opts, _name) do
    {:http_error, reason}
  end

  defp parse_body(body, resource_name) do
    case Poison.decode(body) do
      {:ok, body} ->
        {:ok, body[resource_name] || body}
      {:error, reason} ->
        {:decoding_error, reason}
    end
  end

  @default_base_url "{shop}.myshopify.com"
  @doc """
  Normalizes url, otherwise uses base url, defaults to "{shop}.myshopify.com"
  and configurable in config.exs:

  config :shopify, base_url: "{shop}.example.com"

  ## Examples
    iex> Shopify.shop_url("myshop")
      "https://myshop.myshopify.com"

    iex> Shopify.shop_url("myshop", "{shop}.mydomain.com")
      "https://myshop.mydomain.com"

    iex> Shopify.shop_url("https://myshop.com")
      "https://myshop.com"

    iex> Shopify.shop_url("myshop.com")
      "https://myshop.com"
  """
  def shop_url(url, base_url \\ Config.get(:base_url, @default_base_url)),
    do: Utils.normalize_url(url, base_url)

  # FIXME function below should be concern of AdminAPI context
  defp headers(client, headers),
    do: [auth_header(client), {"accept", "application/json"} | headers]

  defp auth_header(client),
    do: {"X-Shopify-Access-Token", AdminAPI.Token.extract(client)}
end
