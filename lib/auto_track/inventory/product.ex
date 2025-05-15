defmodule AutoTrack.Inventory.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias AutoTrack.Inventory.ProductType

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "products" do
    field :oem_number, :string
    field :car_name, :string
    field :brand, :string
    field :stock_qty, :integer
    field :buying_price, :decimal
    field :selling_price, :decimal

    belongs_to :product_type, ProductType

    embeds_many :product_attributes, ProductAttribute, on_replace: :delete do
      field :attribute_name, :string
      field :attribute_value, :string
    end

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:oem_number, :car_name, :brand, :stock_qty, :buying_price, :selling_price, :product_type_id])
    |> cast_embed(:product_attributes,
      with: &product_attribute_changeset/2,
      sort_param: :product_attributes_sort,
      drop_param: :product_attributes_drop
    )
    |> validate_required([:oem_number, :car_name, :brand, :stock_qty, :buying_price, :selling_price, :product_type_id])
    |> foreign_key_constraint(:product_type_id)
  end

  def product_attribute_changeset(product_attribute, attrs) do
    product_attribute
    |> cast(attrs, [:attribute_name, :attribute_value])
    |> validate_required([:attribute_name, :attribute_value])
  end
end
