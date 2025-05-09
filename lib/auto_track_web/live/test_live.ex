defmodule AutoTrackWeb.TestLive do
  use AutoTrackWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
