defmodule AutoTrack.Inventory.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "products" do
    # Product categorization and identification
    # Product category (e.g., air filter, oil filter, shock bar)
    field :category, :string
    # Original Equipment Manufacturer part number
    field :oem_number, :integer
    # Brand name of the product
    field :brand, :string

    # Inventory and pricing information
    # Current quantity in stock
    field :qty, :integer
    # Cost price of the product
    field :buying_price, :decimal
    # Retail price of the product
    field :selling_price, :decimal

    # Purchase details
    # Date when the product was purchased
    field :purchase_date, :date
    # Supplier or vendor name
    field :purchased_from, :string
    # Path to product image file
    field :image_path, :string

    # Associated product attributes (e.g., specifications, features)
    has_many :attributes, AutoTrack.Inventory.ProductAttribute, on_replace: :delete

    # Timestamps for record creation and updates
    timestamps(type: :utc_datetime)
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :category,
      :oem_number,
      :brand,
      :qty,
      :buying_price,
      :selling_price,
      :purchase_date,
      :purchased_from,
      :image_path
    ])
    |> validate_required([:oem_number, :brand, :qty, :category])
    |> validate_length(:category, min: 2, max: 100)
    |> validate_length(:brand, min: 2, max: 50)
    |> validate_number(:qty, greater_than_or_equal_to: 0)
    |> validate_number(:buying_price, greater_than_or_equal_to: 0)
    |> validate_number(:selling_price, greater_than_or_equal_to: 0)
    |> validate_selling_price()
    |> check_constraint(:purchase_date, name: :purchase_date_not_in_future, message: "cannot be in the future")
    |> validate_length(:purchased_from, min: 2, max: 100)
    |> validate_image_path()
  end

  # Validates that selling price is greater than or equal to buying price
  defp validate_selling_price(changeset) do
    case {get_change(changeset, :selling_price), get_change(changeset, :buying_price)} do
      {selling_price, buying_price} when not is_nil(selling_price) and not is_nil(buying_price) ->
        if Decimal.compare(selling_price, buying_price) == :lt do
          add_error(changeset, :selling_price, "must be greater than or equal to buying price")
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  # Validates image path format
  defp validate_image_path(changeset) do
    case get_change(changeset, :image_path) do
      nil ->
        changeset

      path ->
        if String.ends_with?(path, [".jpg", ".jpeg", ".png", ".gif"]) do
          changeset
        else
          add_error(
            changeset,
            :image_path,
            "must be a valid image file (.jpg, .jpeg, .png, or .gif)"
          )
        end
    end
  end
end
