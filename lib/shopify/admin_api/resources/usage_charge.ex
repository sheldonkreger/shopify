defmodule Shopify.AdminAPI.UsageCharge do
  use Shopify.AdminAPI.Resource,
    name: "usage_charge",
    collection: "recurring_application_charge",
    only: [:all, :get, :create]
end
