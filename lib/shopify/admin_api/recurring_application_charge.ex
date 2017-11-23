defmodule Shopify.AdminAPI.RecurringApplicationCharge do
  use Shopify.AdminAPI.Resource

  @name "recurring_application_charges"

  def get(resource),
    do: Resource.get("#{@name}/#{to_id(resource)}")

  def list,
    do: Resource.get(@name)

  def create(params),
    do: Resource.post(@name, body: params)

  def delete(resource),
    do: Resource.delete("#{@name}/#{to_id(resource)}")

  def update(resource, params),
    do: Resource.put("#{@name}/#{to_id(resource)}/customize", params)

  def activate(resource, params),
    do: Resource.post("#{@name}/#{to_id(resource)}/activate", params)
end
