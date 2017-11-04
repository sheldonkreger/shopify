defmodule ShopifyTest do
  use ExUnit.Case
  doctest Shopify

  test "greets the world" do
    assert Shopify.hello() == :world
  end
end
