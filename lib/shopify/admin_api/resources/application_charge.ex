defmodule Shopify.AdminAPI.ApplicationCharge do
  use Shopify.AdminAPI.Resource, name: "application_charges"

  def activate(application_charge, params),
    do: Resource.post([@resource, to_id(application_charge), "activate"], body: params)
end
