defmodule Shopify.AdminAPI.RecurringApplicationCharge do
  use Shopify.AdminAPI.Resource, name: "recurring_application_charge"

  def activate(recurring_application_charge, body) do
    Resource.post([@pname, to_id(recurring_application_charge), "activate"],
      name: @name,
      body: body)
  end

  def customize(recurring_application_charge, query) do
    Resource.put([@pname, to_id(recurring_application_charge), "customize"],
      name: @name,
      query: query)
  end
end
