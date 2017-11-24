defmodule Shopify.AdminAPI.UsageCharge do
  use Shopify.AdminAPI.Resource

  @name "recurring_application_charges"

  def create(rec_app_charge, params),
    do: Resource.post("#{@name}/#{to_id(rec_app_charge)}/usage_charges", params)

  def get(rec_app_charge, usage_charge),
    do: Resource.get("#{@name}/#{to_id(rec_app_charge)}/usage_charges/#{to_id(usage_charge)}")

  def list(rec_app_charge),
    do: Resource.get("#{@name}/#{to_id(rec_app_charge)}/usage_charges")
end
