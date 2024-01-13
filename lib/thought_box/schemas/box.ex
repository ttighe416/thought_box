defmodule ThoughtBox.Box do
  use Ecto.Schema
  import Ecto.Changeset
  
  schema "boxes" do
    field :name, :string
    has_many :notes, ThoughtBox.Note

    timestamps()
  end

  def changeset(box, params \\ %{}) do
    box
    |> cast(params, [:name])
    |> cast_assoc(:notes, with: &ThoughtBox.Note.changeset/2)
    |> validate_required([:name])
  end
end
