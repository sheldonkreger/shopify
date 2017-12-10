defmodule Shopify.AdminAPI.Order do
  use Shopify.AdminAPI.Resource, name: "order"

  def count(params \\ %{}),
    do: Resource.get([@resource, "count"], query: params, name: "count")

  def close(order),
    do: Resource.post([@resource, to_id(order), "close"])

  def open(order),
    do: Resource.post([@resource, to_id(order), "open"])

  def cancel(order, params \\ %{}),
    do: Resource.post([@resource, to_id(order), "cancel"], body: params)
end
