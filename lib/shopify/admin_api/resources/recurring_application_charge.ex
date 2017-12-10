defmodule Shopify.AdminAPI.RecurringApplicationCharge do
  use Shopify.AdminAPI.Resource, name: "recurring_application_charges"

  def activate(recurring_application_charge, params) do
    Resource.post([@resource, to_id(recurring_application_charge), "activate"], body: params)
  end

  def customize(recurring_application_charge, params) do
    Resource.put([@resource, to_id(recurring_application_charge), "customize"], query: params)
  end
end
