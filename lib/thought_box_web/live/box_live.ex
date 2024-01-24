defmodule ThoughtBoxWeb.BoxLive do
use ThoughtBoxWeb, :live_view
alias ThoughtBox.{Note}


def mount(params, _session, socket) do
  Phoenix.PubSub.subscribe(ThoughtBox.PubSub, "box")

  socket = socket
  |> assign(:box, ThoughtBox.ThoughtBox.get_box(params["box_id"]))
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
<div :if={@box.status == :closed} :for={note <- @box.notes}
 class="transition duration-300 shadow my-5 p-3 hover:shadow-2xl flow-root">
  <span> <%= note.body %> </span>
</div>
<div :if={@box.status == :open}>
  <.form for={@form} phx-submit="save">
    <.input type="text" autofocus placeholder="Add a new note here..." field={@form[:note_body]}/>
  </.form>
  <div class="mt-5"></div>
</div>
  <button phx-click="to_boxes" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
    To Boxes...
  </button>
"""
end

def handle_event("save", %{"note" => note} = params, socket) do
  box = socket.assigns.box
  case ThoughtBox.ThoughtBox.create_note(box, note["note_body"]) do
    {:ok, note} ->
      socket = assign(socket, :box, ThoughtBox.ThoughtBox.get_box(box.id))
      Phoenix.PubSub.broadcast(ThoughtBox.PubSub, "box", {:update_box})

      {:noreply, socket}

    _ -> {:noreply, socket}
  end
end

def handle_event("to_boxes", _params, socket) do
  {:noreply, push_redirect(socket, to: "/boxes")}
end

def handle_info({:update_box, box_id}, socket) do
  {:noreply, assign(socket, :box, ThoughtBox.ThoughtBox.get_box(box_id))}
end

def handle_info({:update_box}, socket) do
  {:noreply, assign(socket, :box, ThoughtBox.ThoughtBox.get_box(socket.assigns.box.id))}
end

end
