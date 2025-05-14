defmodule AutoTrack.Repo.Migrations.CreateInventory do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :oem_number, :string, null: false
      add :car_name, :string, null: false
      add :stock_qty, :integer, null: false
      add :product_attributes, :map, default: "[]"

      timestamps()
    end

    create index(:products, [:oem_number])
  end
end
