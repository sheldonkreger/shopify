defmodule Shopify.AdminAPI.Page do
  use Shopify.AdminAPI.Resource, name: "page"

  def count(params \\ %{}),
    do: Resource.get([@pname, "count"], query: params, name: "count")
end
