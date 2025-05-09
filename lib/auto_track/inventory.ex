
defmodule AutoTrack.Inventory do
  import Ecto.Query, warn: false
  alias AutoTrack.Repo
  alias AutoTrack.Inventory.{Product, ProductAttribute}

  # ----------------------------
  # PRODUCT FUNCTIONS
  # ----------------------------

  def list_products do
    Product
    |> preload(:attributes)
    |> Repo.all()
  end

  def list_products_by_category(category) do
    Product
    |> where([p], p.category == ^category)
    |> preload(:attributes)
    |> Repo.all()
  end

  def get_product!(id) do
    Product
    |> Repo.get!(id)
    |> Repo.preload(:attributes)
  end

  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def create_product_with_attributes(product_attrs, attribute_pairs \\ []) do
    Repo.transaction(fn ->
      with {:ok, product} <- create_product_only(product_attrs) do
        attributes = build_attributes(product.id, attribute_pairs)

        Enum.each(attributes, fn attr ->
          %ProductAttribute{}
          |> ProductAttribute.changeset(attr)
          |> Repo.insert!()
        end)

        Repo.preload(product, :attributes)
      end
    end)
  end

  defp create_product_only(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  # ----------------------------
  # ATTRIBUTE UTILITY
  # ----------------------------

  def build_attributes(product_id, attrs) when is_list(attrs) do
    Enum.map(attrs, fn {key, value} ->
      %{
        product_id: product_id,
        key: key,
        value: value,
        value_type: infer_type(value)
      }
    end)
  end

  defp infer_type(value) when is_binary(value) do
    cond do
      is_integer_string?(value) -> "integer"
      is_float_string?(value) -> "float"
      is_boolean_string?(value) -> "boolean"
      true -> "string"
    end
  end

  defp is_integer_string?(value), do: String.match?(value, ~r/^\d+$/)
  defp is_float_string?(value), do: String.match?(value, ~r/^\d+\.\d+$/)
  defp is_boolean_string?(value), do: value in ["true", "false", "1", "0"]

  # ----------------------------
  # ATTRIBUTE CRUD (Optional)
  # ----------------------------

  def change_attribute(%ProductAttribute{} = attr, attrs \\ %{}) do
    ProductAttribute.changeset(attr, attrs)
  end

  def update_attribute(%ProductAttribute{} = attr, attrs) do
    attr
    |> ProductAttribute.changeset(attrs)
    |> Repo.update()
  end

  def delete_attribute(%ProductAttribute{} = attr) do
    Repo.delete(attr)
  end

  def list_attributes(product_id) do
    ProductAttribute
    |> where([a], a.product_id == ^product_id)
    |> Repo.all()
  end
end
