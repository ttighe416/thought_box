defmodule ThoughtBoxWeb.BoxLive do
use ThoughtBoxWeb, :live_view
alias ThoughtBox.{Note, ThoughtBox}


def mount(params, _session, socket) do
  socket = socket
  |> assign(:box, ThoughtBox.get_box(params["box_id"]))
  |> assign(:form, to_form(Note.changeset(%Note{})))

  {:ok, socket}
end

def render(assigns) do
~H"""
<div class="text-2xl">
  <%= @box.name %>
</div>
<div class="text-xl">
  Number of entries: <%= Enum.count(@box.notes)%>
</div>
<.form for={@form} phx-submit="save">
  <.input type="text" autofocus placeholder="Add a new note here..." field={@form[:note_body]}/>
</.form>
<div class="mt-5"></div>
<button phx-click="to_boxes" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
  To Boxes...
</button>
"""
end

def handle_event("save", %{"note" => note} = params, socket) do
  box = socket.assigns.box
  case ThoughtBox.create_note(box, note["note_body"]) do
    {:ok, note} ->
      socket = assign(socket, :box, ThoughtBox.get_box(box.id))
      {:noreply, socket}

    _ -> {:noreply, socket}
  end
end

def handle_event("to_boxes", _params, socket) do
  {:noreply, push_redirect(socket, to: "/boxes")}
end

end
