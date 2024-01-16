defmodule ThoughtBoxWeb.BoxesLive do
use ThoughtBoxWeb, :live_view
alias ThoughtBox.{Box, ThoughtBox}

  def mount(_params, _session, socket) do
    socket = socket
    |> stream(:boxes, ThoughtBox.get_boxes())
    |> assign(:form, to_form(Box.changeset(%Box{})))
    {:ok, socket}
  end


  def render(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save">
      <.input type="text" autofocus placeholder="Create new box..." field={@form[:name]} />
    </.form>
    <div id="boxes" phx-update="stream">
      <div :for={{id, box} <- @streams.boxes} id={id}
        class="shadow my-5 p-3 hover:shadow-2xl flow-root" phx-click="to_box" phx-value-boxid={"#{box.id}"}>
          <span> <%= box.name %> </span>
          <button class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded float-right"
          phx-click="delete_box" phx-value-boxid={"#{box.id}"}>
            Delete Box
          </button>
      </div>
    </div>
    """
  end

  def handle_event("save", params, socket) do
    case ThoughtBox.create_box(params["box"]) do
      {:ok, box} ->
        socket =
        socket
        |> stream_insert(:boxes, box)
        {:noreply, socket}

      _ -> {:noreply, socket}
    end
  end

  def handle_event("to_box", %{"boxid" => box_id} = _params, socket) do
    {:noreply, push_redirect(socket, to: "/box/#{box_id}")}
  end

  def handle_event("delete_box", %{"boxid" => box_id} = _params, socket) do
    {:ok, box} = ThoughtBox.delete_box(box_id)
    {:noreply, stream_delete(socket, :boxes, box)}
  end
end
