defmodule AutoTrack.Inventory.ProductAttribute do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "product_attributes" do
    field :key, :string
    field :value, :string
    field :value_type, :string

    belongs_to :product, AutoTrack.Inventory.Product

    timestamps()
  end

  def changeset(attribute, attrs) do
    attribute
    |> cast(attrs, [:key, :value, :value_type, :product_id])
    |> validate_required([:key, :product_id, :value_type])
    |> validate_length(:key, min: 2, max: 100)
    |> validate_length(:value, min: 2, max: 100)
    |> validate_inclusion(:value_type, ["string", "integer", "float", "boolean"])
  end


end
