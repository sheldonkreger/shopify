defmodule Shopify.AdminAPI.RecurringApplicationCharge do
  alias Shopify.AdminAPI.{Id, Resource}

  @path "recurring_application_charges"

  def list,
    do: Resource.new(method: :get, path: @path)

  def create(params),
    do: Resource.new(method: :post, body: params, path: @path)

  def get(resource),
    do: Resource.new(method: :get, path: "#{@path}/#{Id.to_id(resource)}")

  def delete(resource),
    do: Resource.new(method: :delete, path: "#{@path}/#{Id.to_id(resource)}")

  def activate(resource, params),
    do: Resource.new(method: :post, path: "#{@path}/#{Id.to_id(resource)}/activate", body: params)

  def update(resource, params),
    do: Resource.new(method: :put, path: "#{@path}/#{Id.to_id(resource)}/customize", query: params)
end
