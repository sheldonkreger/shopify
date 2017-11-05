defmodule Shopify.AdminAPI.Order do
  use Shopify.AdminAPI.Resource

  @name "orders"

  def list(params \\ %{}),
    do: new(method: :get, path: @name, query: params)

  def get(resource, params \\ %{}),
    do: new(method: :get, path: "#{@name}/#{to_id(resource)}", query: params)

  def count(params \\ %{}),
    do: new(method: :get, path: "#{@name}/count", query: params)

  def close(resource),
    do: new(method: :post, path: "#{@name}/#{to_id(resource)}/close")

  def open(resource),
    do: new(method: :post, path: "#{@name}/#{to_id(resource)}/open")

  def cancel(resource, params \\ %{}),
    do: new(method: :post, path: "#{@name}/#{to_id(resource)}/cancel", body: params)

  def create(params \\ %{}),
    do: new(method: :post, path: @name, body: params)

  def update(resource, params),
    do: new(method: :put, path: "#{@name}/#{to_id(resource)}", body: params)

  def delete(resource),
    do: new(method: :delete, path: "#{@name}/#{to_id(resource)}")
end
