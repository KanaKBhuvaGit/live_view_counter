defmodule LiveViewCounterWeb.Counter do
  use LiveViewCounterWeb, :live_view

  @topic "count"

  def mount(_params, _session, socket) do
    LiveViewCounterWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, :val, 0)}
  end

  def handle_event("inc", _, socket) do
    new_state = update(socket, :val, &(&1 + 1))
    LiveViewCounterWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_event("dec", _, socket) do
    new_state = update(socket, :val, &(&1 - 1))
    LiveViewCounterWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, :val, msg.payload.val)}
  end

  def render(assigns) do
    ~H"""
      <div>
        <h1 class="text-4xl font-bold text-center"> The count is: <%= @val %> </h1>
    
        <p class="text-center">
          <button phx-click="dec">-</button>
          <button phx-click="inc">+</button>
        </p>
      </div>
    """
  end
end
