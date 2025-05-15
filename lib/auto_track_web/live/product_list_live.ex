defmodule AutoTrackWeb.ProductListLive do
  use AutoTrackWeb, :live_view

  alias AutoTrack.Inventory

  def mount(%{"product_type_id" => product_type_id}, _session, socket) do
    product_type = Inventory.get_product_type!(product_type_id)
    products = Inventory.list_products_by_product_type(product_type_id)

    socket =
      socket
      |> assign(:product_type, product_type)
      |> assign(:products, products)
      |> assign(:view, :list)

    {:ok, socket}
  end

  def handle_event("set_view", %{"view" => view_str}, socket) do
    new_view =
      case view_str do
        "list" -> :list
        "grid" -> :grid
        _ -> socket.assigns.view
      end

    socket = assign(socket, :view, new_view)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto py-8">
      <.link
        navigate={~p"/product-types"}
        class="text-sm text-blue-600 hover:text-blue-800 flex items-center"
      >
        <.icon name="hero-arrow-left" class="h-4 w-4 mr-1" /> Back to Product Types
      </.link>
      <%= if Enum.empty?(@products) do %>
        <div class="text-center py-10 bg-white shadow-md rounded-lg">
          <p class="text-xl text-gray-500">No products found for this product type yet.</p>
          <p class="mt-2 text-gray-400">You can create the first one!</p>
        </div>
      <% else %>
        <div class="bg-white shadow-md rounded-lg">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th
                  scope="col"
                  class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  OEM Number
                </th>
                <th
                  scope="col"
                  class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  Car Name
                </th>
                <th
                  scope="col"
                  class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  Stock Quantity
                </th>
                <th
                  scope="col"
                  class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  Attributes
                </th>
                <th scope="col" class="relative px-6 py-3">
                  <span class="sr-only">Actions</span>
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr :for={product <- @products} class="hover:bg-gray-50 transition-colors duration-150">
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                  {product.oem_number}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{product.car_name}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{product.stock_qty}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  <%= if Enum.empty?(product.product_attributes) do %>
                    <span class="text-gray-400 italic">No attributes</span>
                  <% else %>
                    <ul class="list-disc list-inside pl-2">
                      <li :for={attr <- product.product_attributes}>
                        {attr.attribute_name}: {attr.attribute_value}
                      </li>
                    </ul>
                  <% end %>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="p-4">
          <h2 class="text-2xl font-bold mb-4">List View or Grid View</h2>
          <p class="mb-4">Click on a button to choose list view or grid view.</p>

          <div id="btnContainer" phx-hook="ViewToggle">
            <button
              class={"btn#{if @view == :list, do: " active", else: ""}"}
              phx-click="set_view"
              phx-value-view="list"
            >
              <i class="fa fa-bars"></i> List
            </button>
            <button
              class={"btn#{if @view == :grid, do: " active", else: ""}"}
              phx-click="set_view"
              phx-value-view="grid"
            >
              <i class="fa fa-th-large"></i> Grid
            </button>
          </div>

          <div class={"mt-4 space-y-4 #{if @view == :list, do: "block", else: "flex flex-wrap -mx-2"}"}>
            <div class={"column #{if @view == :list, do: "w-full", else: "w-full md:w-1/2 px-2 mb-4"} bg-gray-300 p-4"}>
              <h2 class="text-xl font-semibold">Column 1</h2>
              <p>Some text..</p>
            </div>
            <div class={"column #{if @view == :list, do: "w-full", else: "w-full md:w-1/2 px-2 mb-4"} bg-gray-400 p-4"}>
              <h2 class="text-xl font-semibold">Column 2</h2>
              <p>Some text..</p>
            </div>
            <div class={"column #{if @view == :list, do: "w-full", else: "w-full md:w-1/2 px-2 mb-4"} bg-gray-500 p-4"}>
              <h2 class="text-xl font-semibold">Column 3</h2>
              <p>Some text..</p>
            </div>
            <div class={"column #{if @view == :list, do: "w-full", else: "w-full md:w-1/2 px-2 mb-4"} bg-gray-600 p-4"}>
              <h2 class="text-xl font-semibold">Column 4</h2>
              <p>Some text..</p>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
