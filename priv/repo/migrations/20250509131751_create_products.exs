defmodule AutoTrack.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :oem_number, :string, null: false
      add :brand, :string, null: false
      add :qty, :integer, default: 0, null: false
      add :buying_price, :decimal
      add :selling_price, :decimal
      add :category, :string, null: false
      add :purchase_date, :date
      add :purchased_from, :string
      add :image_path, :string

      timestamps()
    end
  end
end
