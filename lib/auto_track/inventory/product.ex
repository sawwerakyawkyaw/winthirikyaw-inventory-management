defmodule AutoTrack.Inventory.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    # Product categorization and identification
    # Product category (e.g., air filter, oil filter, shock bar)
    field :category, :string
    # Original Equipment Manufacturer part number
    field :oem_number, :string
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
    timestamps()
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
  end
end
