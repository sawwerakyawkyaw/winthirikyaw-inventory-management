defmodule AutoTrack.Repo.Migrations.CreateProductAttributes do
  use Ecto.Migration

  def change do
    create table(:product_attributes, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :product_id, references(:products, on_delete: :delete_all, type: :binary_id),
        null: false

      add :key, :string, null: false
      add :value, :string
      add :value_type, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:product_attributes, [:product_id])
  end
end
