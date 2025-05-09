defmodule AutoTrackWeb.Components.UI.Toggle do
  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: AutoTrackWeb.Endpoint,
    router: AutoTrackWeb.Router,
    statics: AutoTrackWeb.static_paths()

  @doc """
  Creates a text-based button to switch between locales.

    ## Examples
      <.toggle locale={@locale} />
  """

  attr :class, :string, default: nil
  attr :locale, :string, required: true, values: ~w(my en)

  def toggle(assigns) do
    ~H"""
    <div class={["text-sm font-medium space-x-1", @class]}>
      <.link
        class={
          if @locale == "my",
            do: "text-color-primary font-bold",
            else: "text-gray-400 hover:underline"
        }
        href={~p"/locale/my"}
        method="PUT"
      >
        မြန်မာ
      </.link>|
      <.link
        class={
          if @locale == "en",
            do: "text-color-primary font-bold",
            else: "text-gray-400 hover:underline"
        }
        href={~p"/locale/en"}
        method="PUT"
      >
        English
      </.link>
    </div>
    """
  end
end
