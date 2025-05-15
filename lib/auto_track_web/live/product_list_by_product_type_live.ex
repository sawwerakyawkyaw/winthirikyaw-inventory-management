defmodule AutoTrackWeb.ProductListByProductTypeLive do
  use AutoTrackWeb, :live_view

  alias AutoTrack.Inventory

  @impl true
  def mount(%{"product_type_id" => product_type_id}, _session, socket) do
    product_type = Inventory.get_product_type!(product_type_id)
    products = Inventory.list_products_by_product_type(product_type_id)

    # Determine the attribute header name
    attribute_header_name =
      cond do
        products == [] -> "Detail" # Default if no products
        first_product_attrs = hd(products).product_attributes ->
          if first_product_attrs == [] do
            "Detail" # Default if first product has no attributes
          else
            hd(first_product_attrs).attribute_name # Name of the first attribute of the first product
          end
        true -> "Detail" # Fallback default
      end

    total_stock_qty = Inventory.total_stock_qty_for_product_type(product_type_id)
    total_value = Inventory.total_inventory_value_by_buying_price_for_product_type(product_type_id)

    socket =
      socket
      |> assign(:product_type, product_type)
      |> assign(:products, products)
      # For the "Create New Product" link, to pass the product_type_id
      |> assign(:current_product_type_id, product_type_id)
      |> assign(:attribute_header_name, attribute_header_name) # Assign to socket
      |> assign(:total_stock_qty, total_stock_qty)
      |> assign(:total_value, total_value)
      |> assign(:product, nil) # Initialize @product

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :view_product, %{"id" => product_id}) do
    socket
    |> assign(:product, Inventory.get_product!(product_id))
  end

  defp apply_action(socket, :edit_product, %{"id" => product_id}) do
    socket
    |> assign(:product, Inventory.get_product!(product_id))
  end

  defp apply_action(socket, :index, _params) do
    # For index action, ensure product is nil (already done by mount or if navigating back)
    # or re-assign if necessary. If products list needs update based on params, do it here.
    assign(socket, :product, nil)
  end

  # Fallback for any other actions or if params don't match
  defp apply_action(socket, _action, _params) do
    assign(socket, :product, nil) # Default to product being nil
  end

  # Helper function to get specific attribute value
  defp get_attribute_value(product, attribute_name) do
    Enum.find_value(product.product_attributes, "N/A", fn attr ->
      if attr.attribute_name == attribute_name, do: attr.attribute_value
    end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto py-8">
      <div class="flex justify-between items-center mb-6">
        <div>
          <.link
            navigate={~p"/product-types"}
            class="text-sm text-blue-600 hover:text-blue-800 flex items-center"
          >
            <.icon name="hero-arrow-left" class="h-4 w-4 mr-1" /> Back to Product Types
          </.link>
          <h1 class="text-3xl font-bold text-gray-800 mt-2">Products for {@product_type.name}</h1>
          <div class="mt-2 text-sm text-gray-600">
            <p>Total In Stock: <span class="font-semibold"><%= @total_stock_qty %></span> units</p>
            <p>Total Inventory Value (Buying Price): <span class="font-semibold"><%= Decimal.to_string(@total_value) %></span></p>
          </div>
        </div>
        <.link
          navigate={~p"/products/new?product_type_id=#{@current_product_type_id}"}
          class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 flex items-center"
        >
          <.icon name="hero-plus-solid" class="h-5 w-5 mr-2" /> Create New Product
        </.link>
      </div>

      <%= if @live_action in [:view_product, :edit_product] do %>
        <.live_component
          module={if @live_action == :view_product, do: AutoTrackWeb.ProductViewLive, else: AutoTrackWeb.ProductEditLive}
          id={@product.id || :new}
          product={@product}
          product_type_id={@product_type.id}
        />
      <% end %>

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
                  Brand
                </th>
                <th
                  scope="col"
                  class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  Stock Quantity
                </th>
                <th
                  scope="col"
                  class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider capitalize"
                >
                  {@attribute_header_name}
                </th>
                <th
                  scope="col"
                  class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  Buying Price
                </th>
                <th
                  scope="col"
                  class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  Selling Price
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
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{product.brand}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{product.stock_qty}</td>

                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  <%= get_attribute_value(product, @attribute_header_name) %>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{product.buying_price}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{product.selling_price}</td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      <% end %>
    </div>
    """
  end
end
