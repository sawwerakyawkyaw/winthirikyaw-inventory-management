defmodule AutoTrackWeb.UserLoginLive do
  use AutoTrackWeb, :live_view
  use Gettext, backend: AutoTrackWeb.Gettext

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
