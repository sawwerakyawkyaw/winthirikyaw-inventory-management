defmodule AutoTrack.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :oem_number, :integer, null: false
      add :brand, :string, null: false
      add :qty, :integer, default: 0, null: false
      add :buying_price, :decimal
      add :selling_price, :decimal
      add :category, :string, null: false
      add :purchase_date, :date
      add :purchased_from, :string
      add :image_path, :string

      timestamps(type: :utc_datetime)
    end

    # Add check constraint to ensure purchase_date is not in the future
    create constraint(:products, :purchase_date_not_in_future,
      check: "purchase_date <= CURRENT_DATE"),
      comment: "Purchase date cannot be in the future"
  end
end
