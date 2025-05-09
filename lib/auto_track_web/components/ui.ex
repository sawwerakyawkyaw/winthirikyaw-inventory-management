defmodule AutoTrackWeb.Components.UI do
  defmacro __using__(_opts) do
    quote do
      import AutoTrackWeb.Components.UI.{
        Navbar,
        Toggle
      }
    end
  end
end
