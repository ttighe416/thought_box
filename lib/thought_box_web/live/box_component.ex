defmodule BoxComponent do
  use Phoenix.LiveComponent


  def render(assigns) do
    ~H"""
    <div class="transition duration-300 shadow my-5 p-3 hover:shadow-2xl flow-root"
     phx-click="to_box" phx-value-boxid={"#{@box.id}"} id={"boxes-#{@box.id}"}>
      <span> <%= @box.name %> </span>
      <span class="text-xs">(<%= @box.status %>)</span>
      <button :if={@box.status == :open }class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded float-right"
        phx-click="close_box" phx-target={@myself} phx-value-boxid={"#{@box.id}"}>
        Close Box
      </button>
      <button class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded float-right"
      phx-click="delete_box" phx-target={@myself} phx-value-boxid={"#{@box.id}"}>
        Delete Box
      </button>
    </div>
    """
  end

  def handle_event("close_box", %{"boxid" => box_id} = _params, socket) do
    {:ok, box} = ThoughtBox.ThoughtBox.close_box(box_id)
    send self(), {:update_box, box}
    {:noreply, socket}
  end

  def handle_event("delete_box", %{"boxid" => box_id} = _params, socket) do
    {:ok, box} = ThoughtBox.ThoughtBox.delete_box(box_id)
    Phoenix.PubSub.broadcast(ThoughtBox.PubSub, "other_boxes", {:delete_box, box_id})
    send self(), {:delete_box, box_id}
    {:noreply, socket}
  end
end
