defmodule ThoughtBox.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :body, :string
    belongs_to :box, ThoughtBox.Box

    timestamps()
  end

  def changeset(note, params \\ %{}) do
    note
    |> cast(params, [:body])
    |> validate_required([:body, :box_id])
    |> validate_length(:body, min: 1)
  end
end
