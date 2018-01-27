defmodule Shopify.AdminAPI.Resource.Verbs do
  alias Shopify.AdminAPI.Resource
  import Inflex, only: [pluralize: 1]

  @moduledoc false

  # TODO verb `count` is also met frequently in resources
  # consider adding option for it

  @default_verbs [:all, :get, :create, :update, :delete]
  defmacro generate(opts) do
    verbs = Keyword.get(opts, :only, @default_verbs)

    unless valid_verbs?(verbs, @default_verbs) do
      raise ArgumentError, "option 'only' should be a list and supports " <>
                           "following verbs #{inspect @default_verbs}, got #{inspect verbs}"
    end

    name = Keyword.fetch!(opts, :name)
    collection = Keyword.get(opts, :collection)

    quote do
      @pname unquote(pluralize(name))
      @pcoll unquote(pluralize(collection))
      @name  unquote(name)
      unquote(make_verbs(verbs, name, collection))
    end
  end

  defp make_verbs(verbs, name, collection) do
    for verb <- verbs do
      {verb_args, method_args} = args(verb, name, collection)
      method = verb_method(verb)
      name = name(verb, name)
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
    resource_path = pluralize(resource)
    if collection do
      {collection, collection_args} = create_vars(collection)
      {[collection], collection_args ++ [resource_path]}
    else
      {[], [resource_path]}
    end
  end

  defp create_vars(arg) do
    pretty_name = Macro.var(String.to_atom(arg), __MODULE__)
    {pretty_name, [pluralize(arg), quote do to_id(unquote(pretty_name)) end]}
  end

  defp valid_verbs?(provided, default) do
    is_list(provided) and MapSet.subset?(MapSet.new(provided), MapSet.new(default))
  end

  defp verb_method(:all),    do: :get
  defp verb_method(:get),    do: :get
  defp verb_method(:create), do: :post
  defp verb_method(:update), do: :put
  defp verb_method(:delete), do: :delete

  defp name(:all, resource), do: pluralize(resource)
  defp name(_, resource),    do: resource

  defp params_to(verb) when verb in ~w(create update delete)a, do: :body
  defp params_to(verb) when verb in ~w(all get)a, do: :query
end
