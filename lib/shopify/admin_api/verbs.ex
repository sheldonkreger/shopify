defmodule Shopify.AdminAPI.Resource.Verbs do
  alias Shopify.AdminAPI.Resource

  @moduledoc false

  @default_verbs [:all, :get, :create, :update, :delete]
  defmacro generate(opts) do
    resource = Keyword.fetch!(opts, :name)
    collection = Keyword.get(opts, :collection)
    verbs = Keyword.get(opts, :only, @default_verbs)

    Module.put_attribute(__CALLER__.module, :resource, Inflex.pluralize(resource))
    Module.put_attribute(__CALLER__.module, :collection, Inflex.pluralize(collection))

    unless valid_verbs?(verbs, @default_verbs) do
      raise ArgumentError, "option 'only' should be a list and supports " <>
                           "following functions #{inspect @default_verbs}, got #{inspect verbs}"
    end

    for verb <- verbs do
      {verb_args, method_args} = args(verb, resource, collection)
      method = verb_method(verb)
      name = name(verb, resource)
      params_to = params_to(verb)
      query_or_body = Macro.var(params_to, __MODULE__)
      quote do
        def unquote(verb)(unquote_splicing(verb_args), unquote(query_or_body) \\ %{}) do
          apply Resource, unquote(method), [
            [unquote_splicing(method_args)],
            [{unquote(params_to), unquote(query_or_body)}, {:name, unquote(name)}]
          ]
        end
      end
    end
  end

  defp args(verb, resource, collection) when verb in ~w(get update delete)a do
    {resource, resource_args} = create_vars(resource)
    if collection do
      {collection, collection_args} = create_vars(collection)
      {[collection, resource], collection_args ++ resource_args}
    else
      {[resource], resource_args}
    end
  end

  defp args(verb, resource, collection) when verb in ~w(all create)a do
    resource_path = Inflex.pluralize(resource)
    if collection do
      {collection, collection_args} = create_vars(collection)
      {[collection], collection_args ++ [resource_path]}
    else
      {[], [resource_path]}
    end
  end

  defp create_vars(arg) do
    pretty_name = Macro.var(String.to_atom(arg), __MODULE__)
    {pretty_name, [Inflex.pluralize(arg), quote do to_id(unquote(pretty_name)) end]}
  end

  defp valid_verbs?(provided, default) do
    is_list(provided) and MapSet.subset?(MapSet.new(provided), MapSet.new(default))
  end

  defp verb_method(:all),    do: :get
  defp verb_method(:get),    do: :get
  defp verb_method(:create), do: :post
  defp verb_method(:update), do: :put
  defp verb_method(:delete), do: :delete

  defp name(:all, resource), do: Inflex.pluralize(resource)
  defp name(_, resource),    do: resource

  defp params_to(verb) when verb in ~w(create update delete)a, do: :body
  defp params_to(verb) when verb in ~w(all get)a, do: :query
end