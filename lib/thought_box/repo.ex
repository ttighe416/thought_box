defmodule ThoughtBox.Repo do
  use Ecto.Repo,
    otp_app: :thought_box,
    adapter: Ecto.Adapters.Postgres
end
