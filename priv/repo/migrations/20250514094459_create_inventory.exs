defmodule AutoTrack.Repo.Migrations.CreateInventory do
  use Ecto.Migration

  def change do
    create table(:product_types, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :string
      add :image_url, :string

      timestamps(type: :utc_datetime)
    end

    create index(:product_types, [:name], unique: true)

    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :oem_number, :string, null: false
      add :car_name, :string, null: false
      add :brand, :string, null: false
      add :stock_qty, :integer, null: false
      add :buying_price, :decimal, null: false
      add :selling_price, :decimal, null: false
      add :product_attributes, :map, default: "[]"

      add :product_type_id, references(:product_types, type: :binary_id, on_delete: :nothing),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:oem_number])

    create index(:products, [:product_type_id])
  end
end
