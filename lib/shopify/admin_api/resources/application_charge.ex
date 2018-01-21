defmodule Shopify.AdminAPI.ApplicationCharge do
  use Shopify.AdminAPI.Resource, name: "application_charge"

  def activate(application_charge, params),
    do: Resource.post([@pname, to_id(application_charge), "activate"],
          name: @name,
          body: params)
end
