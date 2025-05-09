defmodule AutoTrack.Inventory.ProductAttribute do
  use Ecto.Schema
  import Ecto.Changeset

  schema "product_attributes" do
    field :key, :string
    field :value, :string

    belongs_to :product, AutoTrack.Inventory.Product

    timestamps()
  end

  def changeset(attribute, attrs) do
    attribute
    |> cast(attrs, [:key, :value, :product_id])
    |> validate_required([:key, :product_id])
  end
end
