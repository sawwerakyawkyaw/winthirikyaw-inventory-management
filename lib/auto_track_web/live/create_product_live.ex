defmodule AutoTrackWeb.CreateProductLive do
  use AutoTrackWeb, :live_view
  alias AutoTrack.Inventory
  alias AutoTrack.Inventory.Product

  def mount(_params, _session, socket) do
    changeset = Inventory.change_product(%Product{product_attributes: []})

    {:ok,
     socket
     |> assign(:changeset, changeset)
     |> assign(:product_form, to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto">
      <h1 class="text-2xl font-bold mb-6">Create New Product</h1>

      <.form for={@product_form} phx-submit="save" phx-change="validate">
        <div class="space-y-4">
          <div>
            <.input field={@product_form[:oem_number]} label="OEM Number" />
          </div>

          <div>
            <.input field={@product_form[:car_name]} label="Car Name" />
          </div>

          <div>
            <.input field={@product_form[:stock_qty]} label="Stock Quantity" type="number" />
          </div>

          <div class="mt-6">
            <h3 class="text-lg font-medium mb-2">Product Attributes</h3>

            <div class="space-y-3" id="product-attributes-container">
              <.inputs_for :let={attr_form} field={@product_form[:product_attributes]}>
                <div id={"attribute-#{attr_form.index}"} class="flex items-center space-x-2">
                  <input type="hidden" name="product[product_attributes_sort][]" value={attr_form.index} />
                  <div class="flex-1">
                    <.input field={attr_form[:attribute_name]} placeholder="Attribute Name" />
                  </div>
                  <div class="flex-1">
                    <.input field={attr_form[:attribute_value]} placeholder="Attribute Value" />
                  </div>
                  <button
                    type="button"
                    name="product[product_attributes_drop][]"
                    value={attr_form.index}
                    phx-click={JS.dispatch("change")}
                    aria-label="Remove attribute"
                    class="text-red-500 hover:text-red-700"
                  >
                    <.icon name="hero-trash" class="h-5 w-5" />
                  </button>
                </div>
              </.inputs_for>
            </div>

            <input type="hidden" name="product[product_attributes_drop][]" />

            <button
              type="button"
              name="product[product_attributes_sort][]"
              value="new"
              phx-click={JS.dispatch("change")}
              class="mt-3 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            >
              Add Attribute
            </button>
          </div>

          <div class="mt-6">
            <button type="submit" class="px-4 py-2 bg-green-600 text-white rounded">
              Create Product
            </button>
          </div>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    # Ensure product_attributes are correctly structured for validation if empty
    params =
      if product_params["product_attributes"] == %{} && product_params["product_attributes_sort"] == nil && product_params["product_attributes_drop"] == nil do
        Map.put(product_params, "product_attributes", [])
      else
        product_params
      end

    changeset =
      %Product{}
      |> Inventory.change_product(params) # Use modified params
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset, product_form: to_form(changeset))}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    # Ensure product_attributes are correctly structured for saving
    params =
      if product_params["product_attributes"] == %{} && product_params["product_attributes_sort"] == nil && product_params["product_attributes_drop"] == nil do
        Map.put(product_params, "product_attributes", [])
      else
        product_params
      end

    case Inventory.create_product(params) do # Use modified params
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> redirect(to: ~p"/products")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset, product_form: to_form(changeset))}
    end
  end
end
