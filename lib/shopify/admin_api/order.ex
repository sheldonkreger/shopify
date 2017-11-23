defmodule Shopify.AdminAPI.Order do
  use Shopify.AdminAPI.Resource

  @name "orders"

  def list(params \\ %{}),
    do: Resource.get(@name, params)

  def get(resource, query \\ %{}),
    do: Resource.get("#{@name}/#{to_id(resource)}", query)

  def count(params \\ %{}),
    do: Resource.get("#{@name}/count", params)

  def close(resource),
    do: Resource.post("#{@name}/#{to_id(resource)}/close")

  def open(resource),
    do: Resource.post("#{@name}/#{to_id(resource)}/open")

  def cancel(resource, params \\ %{}),
    do: Resource.post("#{@name}/#{to_id(resource)}/cancel", params)

  def create(params \\ %{}),
    do: Resource.post(@name, params)

  def update(resource, params),
    do: Resource.put("#{@name}/#{to_id(resource)}", params)

  def delete(resource),
    do: Resource.delete("#{@name}/#{to_id(resource)}")
end
