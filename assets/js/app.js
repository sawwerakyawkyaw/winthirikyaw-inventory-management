// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

const ViewToggle = {
  mounted() {
    console.log(
      "ViewToggle hook mounted. Current window width:",
      window.innerWidth
    );
    // Check screen width and set initial view
    if (window.innerWidth < 768) {
      // Tailwind's md breakpoint
      console.log(
        "Small screen detected (width < 768px). Pushing 'set_view' event with { view: 'grid' }"
      );
      this.pushEvent("set_view", { view: "grid" });
    } else {
      console.log(
        "Screen width is >= 768px. Initial view will be default (list)."
      );
    }

    const buttons = this.el.querySelectorAll("div[role='button']"); // Changed selector to be more specific

    buttons.forEach((button) => {
      button.addEventListener("click", () => {
        // Logic to add/remove active class can remain if needed,
        // but Phoenix will re-render and apply correct classes based on @view.
        // For simplicity, we can rely on Phoenix to update classes.
        // If you have specific styling tied to an "active" class not handled by Phoenix,
        // you might need to adjust this part.
        console.log(
          "View toggle button clicked. Phoenix LiveView will handle the 'set_view' event via phx-click."
        );
      });
    });
  },
};

let hooks = {
  ViewToggle,
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
