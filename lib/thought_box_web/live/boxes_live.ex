defmodule ThoughtBoxWeb.BoxesLive do
use ThoughtBoxWeb, :live_view
alias ThoughtBox.{Box, ThoughtBox}

def mount(_params, _session, socket) do
  socket = socket
  |> assign(:boxes, ThoughtBox.get_boxes())
  |> assign(:form, to_form(Box.changeset(%Box{})))

  {:ok, socket}
end


def render(assigns) do
  ~H"""
  <div :for={box <- @boxes}>
    <%= box.name %>
  </div>
  <.form for={@form} phx-submit="save">
    <.input type="text" autofocus placeholder="Create new box..." field={@form[:name]} />
  </.form>
  """
end

def handle_event("save", params, socket) do
  case ThoughtBox.create_box(params["box"]) do
    {:ok, box} ->
      socket =
      socket
      |> assign(:boxes, [box | socket.assigns.boxes])
      |> put_flash(:success, "Box created successfully")
      {:noreply, socket}

    _ -> {:noreply, socket}
  end
end

end
