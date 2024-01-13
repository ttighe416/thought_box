defmodule ThoughtBox.Repo.Migrations.CreateNotesAndBoxes do
  use Ecto.Migration

  def change do
    create table(:boxes) do
      add :name, :string

      timestamps()
    end

    create table(:notes) do
      add :body, :string
      add :box_id, references(:boxes)

      timestamps()
    end
  end
end
