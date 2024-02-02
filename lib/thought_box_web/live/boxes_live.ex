defmodule ThoughtBoxWeb.BoxesLive do
use ThoughtBoxWeb, :live_view
alias ThoughtBox.{Box}

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(ThoughtBox.PubSub, "other_boxes")
    socket = socket
    |> stream(:boxes, ThoughtBox.ThoughtBox.get_boxes())
    |> assign(:form, to_form(Box.changeset(%Box{})))
    {:ok, socket}
  end


  def render(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save">
      <.input type="text" autofocus placeholder="Create new box..." field={@form[:name]} />
    </.form>
    <div id="boxes" phx-update="stream">
      <%= for {id, box} <- @streams.boxes do %>
        <.live_component module={BoxComponent} id={id} box={box}/>
      <% end %>
    </div>
    """
  end

  def handle_event("save", params, socket) do
    case ThoughtBox.ThoughtBox.create_box(params["box"]) do
      {:ok, box} ->
        socket =
        socket
        |> stream_insert(:boxes, box)
        |> Phoenix.LiveView.put_flash(:success, "Box successfully created.")
        Phoenix.PubSub.broadcast(ThoughtBox.PubSub, "other_boxes", {:add_box, box})
        {:noreply, socket}

      _ -> {:noreply, socket}
    end
  end

  def handle_event("to_box", %{"boxid" => box_id} = _params, socket) do
    {:noreply, push_redirect(socket, to: "/box/#{box_id}")}
  end

  def handle_info({:update_box, box}, socket) do
    {:noreply, stream_insert(socket, :boxes, box)}
  end

  def handle_info({:delete_box, box_id}, socket) do
    {:noreply, stream_delete_by_dom_id(socket, :boxes, "boxes-#{box_id}")}
  end

  def handle_info({:add_box, box}, socket) do
    {:noreply, stream_insert(socket, :boxes, box)}
  end

  def handle_info({:update_box, box}, socket) do
    {:noreply, stream_insert(socket, :boxes, box)}
  end


end
