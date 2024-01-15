defmodule ThoughtBox.ThoughtBox do
  alias ThoughtBox.{Box, Note}
  import Ecto.Query

  def create_box(box) do
    Box.changeset(%Box{}, box)
    |> ThoughtBox.Repo.insert()
  end

  def create_note(box, note_body) do
    note = Ecto.build_assoc(box, :notes, %{body: note_body})
    Note.changeset(note)
    |> ThoughtBox.Repo.insert()
  end

  def get_box(box_id) do
    query = from b in Box, where: b.id == ^box_id, preload: [:notes]
    ThoughtBox.Repo.one(query)
  end

  def get_boxes() do
    ThoughtBox.Repo.all(Box)
  end
end
