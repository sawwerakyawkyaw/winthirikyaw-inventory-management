defmodule AutoTrack.Inventory.ProductType do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "product_types" do
    field :name, :string
    field :description, :string
    field :image_url, :string
    has_many :products, AutoTrack.Inventory.Product

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(product_type, attrs) do
    product_type
    |> cast(attrs, [:name, :description, :image_url])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
