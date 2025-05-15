defmodule AutoTrackWeb.CreateProductLive do
  use AutoTrackWeb, :live_view
  alias AutoTrack.Inventory
  alias AutoTrack.Inventory.Product

  def mount(_params, _session, socket) do
    # No product_type_id in URL, standard behavior
    changeset = Inventory.change_product(%Product{product_attributes: []})
    product_types = Inventory.list_product_types()

    {:ok,
     socket
     |> assign(:changeset, changeset)
     |> assign(:product_form, to_form(changeset))
     |> assign(:product_types_for_select, Enum.map(product_types, fn pt -> {pt.name, pt.id} end))}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
      <.form
        for={@product_form}
        phx-submit="save"
        phx-change="validate"
        class="bg-white shadow-xl rounded-lg p-8 space-y-8"
      >
      <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center">
      Create New Product
      </h1>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <.input field={@product_form[:oem_number]} label="OEM Number" required placeholder="e.g., 12345-ABCDE" />
          </div>

          <div>
            <.input field={@product_form[:car_name]} label="Car Name" required placeholder="e.g., Toyota Camry" />
          </div>

          <div>
            <.input field={@product_form[:brand]} label="Brand" required placeholder="e.g., Denso" />
          </div>

          <div>
            <.input field={@product_form[:stock_qty]} label="Stock Quantity" type="number" required placeholder="e.g., 10" />
          </div>

          <div>
            <.input field={@product_form[:buying_price]} label="Buying Price" type="number" step="0.01" required placeholder="e.g., 25.50" />
          </div>

          <div>
            <.input field={@product_form[:selling_price]} label="Selling Price" type="number" step="0.01" required placeholder="e.g., 45.99" />
          </div>

          <div class="md:col-span-2">
            <.input
              type="select"
              field={@product_form[:product_type_id]}
              label="Product Type"
              options={@product_types_for_select}
              prompt="Select a product type"
              required
            />
          </div>
        </div>

        <div class="border-t border-gray-200 pt-8">
          <h3 class="text-xl font-semibold text-gray-700 mb-6">Product Attributes</h3>

          <div class="space-y-4" id="product-attributes-container">
            <.inputs_for :let={attr_form} field={@product_form[:product_attributes]}>
              <div class={"attribute-#{attr_form.index} flex items-end space-x-3 p-4 border border-gray-200 rounded-md bg-gray-50"}>
                <input
                  type="hidden"
                  name={"#{@product_form.name}[product_attributes_sort][]"}
                  value={attr_form.index}
                />
                <div class="flex-1">
                  <.input field={attr_form[:attribute_name]} placeholder="Attribute Name" label="Name" />
                </div>
                <div class="flex-1">
                  <.input field={attr_form[:attribute_value]} placeholder="Attribute Value" label="Value" />
                </div>
                <button
                  type="button"
                  name={"#{@product_form.name}[product_attributes_drop][]"}
                  value={attr_form.index}
                  phx-click={JS.dispatch("change")}
                  aria-label="Remove attribute"
                  class="p-2 text-red-600 hover:text-red-800 transition-colors duration-150"
                >
                  <.icon name="hero-trash-solid" class="h-6 w-6" />
                </button>
              </div>
            </.inputs_for>
          </div>

          <input type="hidden" name={"#{@product_form.name}[product_attributes_drop][]"} />

          <button
            type="button"
            name={"#{@product_form.name}[product_attributes_sort][]"}
            value="new"
            phx-click={JS.dispatch("change")}
            class="mt-6 flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            <.icon name="hero-plus-solid" class="h-5 w-5 mr-2" />
            Add Attribute
          </button>
        </div>

        <div class="border-t border-gray-200 pt-8 flex justify-between items-center">
          <.button
            type="submit"
            phx-disable-with="Saving..."
            class="px-6 py-3 bg-green-600 hover:bg-green-700 text-white rounded-md text-lg font-semibold shadow-md transition-colors duration-150"
          >
            <%= if @product_form.source.action == :edit, do: "Update Product", else: "Create Product" %>
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    # Ensure product_attributes are correctly structured for validation if empty
    params =
      if product_params["product_attributes"] == %{} &&
           product_params["product_attributes_sort"] == nil &&
           product_params["product_attributes_drop"] == nil do
        Map.put(product_params, "product_attributes", [])
      else
        product_params
      end

    changeset =
      %Product{}
      # Use modified params
      |> Inventory.change_product(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset, product_form: to_form(changeset))}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    # Ensure product_attributes are correctly structured for saving
    params =
      if product_params["product_attributes"] == %{} &&
           product_params["product_attributes_sort"] == nil &&
           product_params["product_attributes_drop"] == nil do
        Map.put(product_params, "product_attributes", [])
      else
        product_params
      end

    # Use modified params
    case Inventory.create_product(params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_navigate(to: "/product-types/#{product_params["product_type_id"]}/products")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset, product_form: to_form(changeset))}
    end
  end
end
