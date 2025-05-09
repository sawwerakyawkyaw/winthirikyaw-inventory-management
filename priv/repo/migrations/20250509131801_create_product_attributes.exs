defmodule AutoTrack.Repo.Migrations.CreateProductAttributes do
  use Ecto.Migration

  def change do
    create table(:product_attributes) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :key, :string, null: false
      add :value, :string

      timestamps()
    end

    create index(:product_attributes, [:product_id])
  end
end
