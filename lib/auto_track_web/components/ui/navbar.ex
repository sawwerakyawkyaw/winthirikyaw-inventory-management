defmodule AutoTrackWeb.Components.UI.Navbar do
  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: AutoTrackWeb.Endpoint,
    router: AutoTrackWeb.Router,
    statics: AutoTrackWeb.static_paths()

  def navbar(assigns) do
    ~H"""
    <ul class="relative z-10 flex items-center gap-4 px-4 sm:px-6 lg:px-8 justify-end">
      <%= if @current_user do %>
        <li class="text-[0.8125rem] leading-6 text-zinc-900">
          {@current_user.name} ({@current_user.email})
        </li>
        <li>
          <.link
            href={~p"/users/settings"}
            class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
          >
            Settings
          </.link>
        </li>
        <li>
          <.link
            href={~p"/users/log_out"}
            method="delete"
            class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
          >
            Log out
          </.link>
        </li>
      <% else %>
        <li>
          <.link
            href={~p"/users/register"}
            class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
          >
            Register
          </.link>
        </li>
        <li>
          <.link
            href={~p"/users/log_in"}
            class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
          >
            Log in
          </.link>
        </li>
      <% end %>
    </ul>
    """
  end
end
