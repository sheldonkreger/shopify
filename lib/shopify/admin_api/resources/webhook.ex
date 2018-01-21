defmodule Shopify.AdminAPI.Webhook do
  use Shopify.AdminAPI.Resource, name: "webhook"

  def count(params \\ %{}),
    do: Resource.get([@pname, "count"], query: params, name: "count")
end
