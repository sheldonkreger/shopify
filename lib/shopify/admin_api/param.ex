defprotocol Shopify.AdminAPI.Param do
  @fallback_to_any true

  @spec to_id(any) :: non_neg_integer
  def to_id(arg)

  @spec to_token(any) :: binary
  def to_token(arg)
end

defimpl Shopify.AdminAPI.Param, for: Any do
  def to_id(arg), do: arg
  def to_token(arg), do: arg
end
