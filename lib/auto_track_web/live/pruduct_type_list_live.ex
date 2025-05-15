defmodule AutoTrackWeb.ProductTypeListLive do
  use AutoTrackWeb, :live_view

  alias AutoTrack.Inventory

  def mount(_params, _session, socket) do
    product_types_with_totals =
      Inventory.list_product_types()
      |> Enum.map(fn pt ->
        total_stock = Inventory.total_stock_qty_for_product_type(pt.id)
        inventory_value = Inventory.total_inventory_value_by_buying_price_for_product_type(pt.id)
        Map.merge(pt, %{total_stock: total_stock, inventory_value: inventory_value})
      end)

    {:ok, socket |> assign(product_types: product_types_with_totals) |> assign(:view, :list)}
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
    <div class="max-w-4xl mx-auto py-8">
      <div class="p-4">
        <div class="flex justify-between items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-800">Product Types</h1>
        </div>

        <div id="btnContainer" phx-hook="ViewToggle" class="flex items-center space-x-2 mb-4">
          <div
            class={"flex items-center p-2 rounded-md hover:bg-gray-100 cursor-pointer#{if @view == :list, do: " bg-gray-200 font-semibold", else: " text-gray-600"}"}
            phx-click="set_view"
            phx-value-view="list"
            role="button"
            tabindex="0"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="20"
              height="20"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="lucide lucide-layout-list-icon lucide-layout-list mr-2"
            >
              <rect width="7" height="7" x="3" y="3" rx="1" /><rect
                width="7"
                height="7"
                x="3"
                y="14"
                rx="1"
              /><path d="M14 4h7" /><path d="M14 9h7" /><path d="M14 15h7" /><path d="M14 20h7" />
            </svg>
            <span>List</span>
          </div>
          <div
            class={"flex items-center p-2 rounded-md hover:bg-gray-100 cursor-pointer#{if @view == :grid, do: " bg-gray-200 font-semibold", else: " text-gray-600"}"}
            phx-click="set_view"
            phx-value-view="grid"
            role="button"
            tabindex="0"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="20"
              height="20"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="lucide lucide-layout-grid-icon lucide-layout-grid mr-2"
            >
              <rect width="7" height="7" x="3" y="3" rx="1" /><rect
                width="7"
                height="7"
                x="14"
                y="3"
                rx="1"
              /><rect width="7" height="7" x="14" y="14" rx="1" /><rect
                width="7"
                height="7"
                x="3"
                y="14"
                rx="1"
              />
            </svg>
            <span>Grid</span>
          </div>
        </div>

        <div class={"mt-6 #{if @view == :list, do: "space-y-4", else: "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"}"}>
          <div :for={product_type <- @product_types}>
            <%= if @view == :list do %>
              <%!-- <%# --- LIST VIEW ITEM --- %> --%>
              <.link
                navigate={~p"/product-types/#{product_type.id}/products"}
                class="block no-underline text-inherit"
              >
                <div class="grid grid-cols-5 gap-x-0 border border-gray-200 rounded-lg p-4 shadow-sm bg-white
                            transition-all duration-300 ease-in-out hover:shadow-md hover:scale-105">
                  <div class="col-span-1 flex flex-col justify-center items-start pr-6 border-gray-200">
                    <img
                      src={product_type.image_url}
                      alt={product_type.name}
                      class="w-full h-full object-cover rounded-lg"
                    />
                  </div>

                  <%!-- <%# Category Info - takes more space %> --%>
                  <div class="col-span-1 flex flex-col justify-center items-start pr-3 border-r border-gray-200">
                    <h2
                      class="text-xl font-semibold text-gray-800 leading-tight"
                      title={product_type.name}
                    >
                      {product_type.name}
                    </h2>
                    <p class="text-sm text-gray-500 mt-1" title={product_type.description}>
                      {product_type.description}
                    </p>
                  </div>

                  <%!-- <%# Product Count Info %> --%>
                  <div class="col-span-1 flex flex-col justify-center items-center px-3 border-r border-gray-200 text-center">
                    <h3 class="text-xs font-medium text-gray-500 uppercase tracking-wider">
                      PRODUCTS
                    </h3>
                    <div class="flex items-center justify-center gap-1 mt-1">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        class="w-5 h-5 text-gray-500 mr-2 lucide lucide-box-icon lucide-box"
                      >
                        <path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z" /><path d="m3.3 7 8.7 5 8.7-5" /><path d="M12 22V12" />
                      </svg>
                      <p class="text-base font-semibold text-gray-700">
                        {Enum.count(product_type.products)}
                      </p>
                    </div>
                  </div>

                  <%!-- <%# Placeholder Stock Info %> --%>
                  <div class="col-span-1 flex flex-col justify-center items-center px-3 border-r border-gray-200 text-center">
                    <h3 class="text-xs font-medium text-gray-500 uppercase tracking-wider">
                      IN STOCK
                    </h3>
                    <div class="flex items-center justify-center gap-1 mt-1">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        class="w-5 h-5 text-gray-500 mr-2 lucide lucide-file-box-icon lucide-file-box"
                      >
                        <path d="M14.5 22H18a2 2 0 0 0 2-2V7l-5-5H6a2 2 0 0 0-2 2v4" /><path d="M14 2v4a2 2 0 0 0 2 2h4" /><path d="M3 13.1a2 2 0 0 0-1 1.76v3.24a2 2 0 0 0 .97 1.78L6 21.7a2 2 0 0 0 2.03.01L11 19.9a2 2 0 0 0 1-1.76V14.9a2 2 0 0 0-.97-1.78L8 11.3a2 2 0 0 0-2.03-.01Z" /><path d="M7 17v5" /><path d="M11.7 14.2 7 17l-4.7-2.8" />
                      </svg>
                      <p class="text-base font-semibold text-gray-700">
                        {product_type.total_stock}
                      </p>
                    </div>
                  </div>

                  <%!-- <%# Placeholder Total Value %> --%>
                  <div class="col-span-1 flex flex-col justify-center items-center pl-3 text-center">
                    <h3 class="text-xs font-medium text-gray-500 uppercase tracking-wider">Inventory Value</h3>
                    <div class="flex items-center justify-center gap-1 mt-1">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        class="w-5 h-5 text-gray-500 mr-2 lucide lucide-circle-dollar-sign-icon lucide-circle-dollar-sign"
                      >
                        <circle cx="12" cy="12" r="10" /><path d="M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8" /><path d="M12 18V6" />
                      </svg>
                      <p class="text-base font-semibold text-gray-700">
                        <%= Decimal.to_string(product_type.inventory_value) %>
                      </p>
                    </div>
                  </div>
                </div>
              </.link>
            <% else %>
              <%!-- <%# --- GRID VIEW ITEM --- %> --%>
              <.link
                navigate={~p"/product-types/#{product_type.id}/products"}
                class="block no-underline text-inherit"
              >
                <div class="w-full max-w-sm bg-white rounded-lg border-gray-200 shadow-sm overflow-hidden transition-all duration-300 ease-in-out hover:shadow-md border hover:scale-105">
                  <div class="relative h-52 overflow-hidden">
                    <img
                      src={product_type.image_url}
                      alt={product_type.name}
                      class="w-full h-full object-cover"
                    />
                    <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                  </div>

                  <div class="p-5">
                    <div class="flex flex-col items-start justify-between pb-4">
                      <h2 class="text-xl font-semibold text-gray-800 truncate" title={product_type.name}>
                        {product_type.name}
                      </h2>
                    </div>

                    <div class="space-y-2">
                      <div class="flex items-center justify-between">
                        <div class="flex items-center gap-2">
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            class="w-5 h-5 text-gray-500 lucide lucide-box-icon lucide-box"
                          >
                            <path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z" /><path d="m3.3 7 8.7 5 8.7-5" /><path d="M12 22V12" />
                          </svg>
                          <span class="text-xs font-medium text-gray-500 uppercase tracking-wider">
                            PRODUCTS
                          </span>
                        </div>
                        <span class="text-xs font-medium text-gray-500 uppercase tracking-wider">
                          {Enum.count(product_type.products)}
                        </span>
                      </div>

                      <div class="flex items-center justify-between">
                        <div class="flex items-center gap-2">
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            class="w-5 h-5 text-gray-500 lucide lucide-file-box-icon lucide-file-box"
                          >
                            <path d="M14.5 22H18a2 2 0 0 0 2-2V7l-5-5H6a2 2 0 0 0-2 2v4" /><path d="M14 2v4a2 2 0 0 0 2 2h4" /><path d="M3 13.1a2 2 0 0 0-1 1.76v3.24a2 2 0 0 0 .97 1.78L6 21.7a2 2 0 0 0 2.03.01L11 19.9a2 2 0 0 0 1-1.76V14.9a2 2 0 0 0-.97-1.78L8 11.3a2 2 0 0 0-2.03-.01Z" /><path d="M7 17v5" /><path d="M11.7 14.2 7 17l-4.7-2.8" />
                          </svg>
                          <span class="text-xs font-medium text-gray-500 uppercase tracking-wider">
                            IN STOCK
                          </span>
                        </div>
                        <span class="text-xs font-medium text-gray-500 uppercase tracking-wider">
                          {product_type.total_stock}
                        </span>
                      </div>

                      <div class="flex items-center justify-between">
                        <div class="flex items-center gap-2">
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            class="w-5 h-5 text-gray-500 lucide lucide-circle-dollar-sign-icon lucide-circle-dollar-sign"
                          >
                            <circle cx="12" cy="12" r="10" /><path d="M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8" /><path d="M12 18V6" />
                          </svg>
                          <span class="text-xs font-medium text-gray-500 uppercase tracking-wider">
                            INVENTORY VALUE
                          </span>
                        </div>
                        <span class="font-medium text-sm text-green-700">
                          <%= Decimal.to_string(product_type.inventory_value) %>
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
              </.link>
            <% end %>
          </div>
        </div>
      </div>
      <%= if Enum.empty?(@product_types) do %>
        <p class="text-center text-gray-500 mt-6">
          No product types found. You can create them if you have an admin interface for product types.
        </p>
      <% end %>
    </div>
    """
  end
end
