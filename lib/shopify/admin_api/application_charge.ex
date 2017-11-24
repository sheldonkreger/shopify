defmodule Shopify.AdminAPI.ApplicationCharge do
  use Shopify.AdminAPI.Resource

  @name "application_charges"

  def create(params),
    do: Resource.post(@name, params)

  def get(resource),
    do: Resource.get("#{@name}/#{to_id(resource)}")

  def list,
    do: Resource.get(@name)

  def activate(resource, params),
    do: Resource.post("#{@name}/#{to_id(resource)}/activate", params)
end
