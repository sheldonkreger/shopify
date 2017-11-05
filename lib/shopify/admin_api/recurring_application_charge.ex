defmodule Shopify.AdminAPI.RecurringApplicationCharge do
  use Shopify.AdminAPI.Resource

  @name "recurring_application_charges"

  def list,
    do: new(method: :get, path: @name)

  def create(params),
    do: new(method: :post, body: params, path: @name)

  def get(resource),
    do: new(method: :get, path: "#{@name}/#{to_id(resource)}")

  def delete(resource),
    do: new(method: :delete, path: "#{@name}/#{to_id(resource)}")

  def activate(resource, params),
    do: new(method: :post, path: "#{@name}/#{to_id(resource)}/activate", body: params)

  def update(resource, params),
    do: new(method: :put, path: "#{@name}/#{to_id(resource)}/customize", query: params)
end
