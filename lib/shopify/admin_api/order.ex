defmodule Shopify.AdminAPI.Order do
  alias Shopify.AdminAPI.{Id, Resource}

  @path "orders"

  def list(params \\ %{}),
    do: Resource.new(method: :get, path: @path, query: params)

  def get(resource, params \\ %{}),
    do: Resource.new(method: :get, path: "#{@path}/#{Id.to_id(resource)}", query: params)

  def count(params \\ %{}),
    do: Resource.new(method: :get, path: "#{@path}/count", query: params)

  def close(resource),
    do: Resource.new(method: :post, path: "#{@path}/#{Id.to_id(resource)}/close")

  def open(resource),
    do: Resource.new(method: :post, path: "#{@path}/#{Id.to_id(resource)}/open")

  def cancel(resource, params \\ %{}),
    do: Resource.new(method: :post, path: "#{@path}/#{Id.to_id(resource)}/cancel", body: params)

  def create(params \\ %{}),
    do: Resource.new(method: :post, path: @path, body: params)

  def update(resource, params),
    do: Resource.new(method: :put, path: "#{@path}/#{Id.to_id(resource)}", body: params)

  def delete(resource),
    do: Resource.new(method: :delete, path: "#{@path}/#{Id.to_id(resource)}")
end
