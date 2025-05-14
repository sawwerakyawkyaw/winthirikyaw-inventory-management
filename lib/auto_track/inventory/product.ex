defmodule AutoTrack.Inventory.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "products" do
    field :oem_number, :string
    field :car_name, :string
    field :stock_qty, :integer

    # embeds_many will create a JSONB column named "product_attributes"
    embeds_many :product_attributes, ProductAttribute, on_replace: :delete do
      field :attribute_name, :string
      field :attribute_value, :string
    end

    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:oem_number, :car_name, :stock_qty])
    |> cast_embed(:product_attributes,
      with: &product_attribute_changeset/2,
      sort_param: :product_attributes_sort,
      drop_param: :product_attributes_drop
    )
    |> validate_required([:oem_number, :car_name, :stock_qty])
  end

  def product_attribute_changeset(product_attribute, attrs) do
    product_attribute
    |> cast(attrs, [:attribute_name, :attribute_value])
    |> validate_required([:attribute_name, :attribute_value])
  end
end
