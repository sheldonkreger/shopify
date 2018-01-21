defmodule Shopify.AdminAPI.Order do
  use Shopify.AdminAPI.Resource, name: "order"

  def count(params \\ %{}),
    do: Resource.get([@pname, "count"], query: params, name: "count")

  def close(order),
    do: Resource.post([@pname, to_id(order), "close"], name: @name)

  def open(order),
    do: Resource.post([@pname, to_id(order), "open"], name: @name)

  def cancel(order, params \\ %{}),
    do: Resource.post([@pname, to_id(order), "cancel"], name: @name, body: params)
end
