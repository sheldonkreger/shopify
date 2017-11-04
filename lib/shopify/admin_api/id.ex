defprotocol Shopify.AdminAPI.Id do
  @spec to_id(any) :: non_neg_integer
  def to_id(arg)
end
