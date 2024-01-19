defmodule ThoughtBox.Repo.Migrations.AddBoxStatus do
  use Ecto.Migration

  def change do
      alter table("boxes") do
        add :status, :string
      end
  end
end
