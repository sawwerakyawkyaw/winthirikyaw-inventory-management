defmodule AutoTrack.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias AutoTrack.Repo

  alias AutoTrack.Inventory.Product
  alias AutoTrack.Inventory.ProductType

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Gets a single product.

  Returns nil if the Product does not exist.

  ## Examples

      iex> get_product(123)
      %Product{}

      iex> get_product(456)
      nil

  """
  def get_product(id), do: Repo.get(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  @doc """
  Returns the list of products with stock quantity less than or equal to the given threshold.

  ## Examples

      iex> list_low_stock_products(5)
      [%Product{}, ...]

  """
  def list_low_stock_products(threshold) do
    from(p in Product, where: p.stock_qty <= ^threshold)
    |> Repo.all()
  end

  @doc """
  Searches products by OEM number, car name, or product attributes.

  ## Examples

      iex> search_products("Toyota")
      [%Product{}, ...]

  """
  def search_products(search_term) do
    search_term = "%#{search_term}%"

    query =
      from p in Product,
        where:
          ilike(p.oem_number, ^search_term) or
            ilike(p.car_name, ^search_term)

    Repo.all(query)
  end

  # --- ProductType functions ---

  @doc """
  Returns the list of product_types.

  ## Examples

      iex> list_product_types()
      [%ProductType{}, ...]

  """
  def list_product_types do
    Repo.all(ProductType)
    |> Repo.preload(:products)
  end

  @doc """
  Gets a single product_type.

  Raises `Ecto.NoResultsError` if the ProductType does not exist.

  ## Examples

      iex> get_product_type!(123)
      %ProductType{}

      iex> get_product_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_type!(id), do: Repo.get!(ProductType, id)

  @doc """
  Gets a single product_type.

  Returns nil if the ProductType does not exist.

  ## Examples

      iex> get_product_type(123)
      %ProductType{}

      iex> get_product_type(456)
      nil
  """
  def get_product_type(id), do: Repo.get(ProductType, id)

  @doc """
  Creates a product_type.

  ## Examples

      iex> create_product_type(%{field: value})
      {:ok, %ProductType{}}

      iex> create_product_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_type(attrs \\ %{}) do
    %ProductType{}
    |> ProductType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_type.

  ## Examples

      iex> update_product_type(product_type, %{field: new_value})
      {:ok, %ProductType{}}

      iex> update_product_type(product_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_type(%ProductType{} = product_type, attrs) do
    product_type
    |> ProductType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_type.

  ## Examples

      iex> delete_product_type(product_type)
      {:ok, %ProductType{}}

      iex> delete_product_type(product_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_type(%ProductType{} = product_type) do
    Repo.delete(product_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_type changes.

  ## Examples

      iex> change_product_type(product_type)
      %Ecto.Changeset{data: %ProductType{}}

  """
  def change_product_type(%ProductType{} = product_type, attrs \\ %{}) do
    ProductType.changeset(product_type, attrs)
  end

  @doc """
  Gets a single product_type by its name.

  Returns nil if the ProductType does not exist.
  """
  def get_product_type_by_name(name) do
    Repo.get_by(ProductType, name: name)
  end

  @doc """
  Lists all products belonging to a specific product type.

  ## Examples

      iex> list_products_by_product_type(product_type_id)
      [%Product{}, ...]

  """
  def list_products_by_product_type(product_type_id) do
    Product
    |> where(product_type_id: ^product_type_id)
    |> Repo.all()
  end

  @doc """
  Calculates the total stock quantity for all products of a given product type.

  ## Examples

      iex> total_stock_qty_for_product_type(product_type_id)
      100
  """
  def total_stock_qty_for_product_type(product_type_id) do
    Product
    |> where(product_type_id: ^product_type_id)
    |> select([p], sum(p.stock_qty))
    |> Repo.one()
    |> then(fn total -> total || 0 end) # Return 0 if nil (no products or all stock_qty is nil)
  end

  @doc """
  Calculates the total selling price for all products of a given product type.

  ## Examples

      iex> total_selling_price_for_product_type(product_type_id)
      1500.00
  """
  def total_selling_price_for_product_type(product_type_id) do
    Product
    |> where(product_type_id: ^product_type_id)
    |> select([p], sum(p.selling_price))
    |> Repo.one()
    |> then(fn total -> total || Decimal.new(0) end) # Return Decimal.new(0) if nil
  end

  @doc """
  Calculates the total inventory value based on buying price for all products
  associated with a given product type ID.

  The value is calculated as the sum of (stock_qty * buying_price) for each product.
  Returns a Decimal.

  ## Examples

      iex> total_inventory_value_by_buying_price_for_product_type(product_type_id)
      %Decimal{}

  """
  def total_inventory_value_by_buying_price_for_product_type(product_type_id) do
    query =
      from p in Product,
      where: p.product_type_id == ^product_type_id,
      select: {p.stock_qty, p.buying_price}

    Repo.all(query)
    |> Enum.reduce(Decimal.new(0), fn {stock_qty, buying_price}, acc ->
      # Ensure stock_qty and buying_price are not nil before multiplication
      if is_number(stock_qty) and buying_price do
        # stock_qty is an integer, buying_price is a Decimal. Convert stock_qty to Decimal.
        product_value = Decimal.mult(Decimal.new(stock_qty), buying_price)
        Decimal.add(acc, product_value)
      else
        acc # If stock_qty or buying_price is nil, skip this product's value
      end
    end)
  end
end
