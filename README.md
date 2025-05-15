# AutoTrack

This document provides instructions on how to set up and run my CSCI-379 final project. Autotrack is an inventory management system for a small business in Myanmar (Burma)

I was working on my final project in a different repositry and it was really hard to merge back to my course repository and I take full responsible of this, weather this is points reduction. However, I have provided step-by-step guide on how you can clone my project and run it locally.

### Setup Instructions

1.  **Clone the Repository (if you haven't already):**

    ```bash
    git clone https://github.com/sawwerakyawkyaw/winthirikyaw-inventory-management
    cd winthirikyaw-inventory-management
    ```

2.  **Install Dependencies and Set Up the Database:**
    The `mix setup` command is a convenient way to handle most initial setup tasks.

    ```bash
    mix deps.get
    mix ecto.create
    mix ecto.migrate
    ```

3.  **Run the seeds to populate the database to interact with my application**
    ```bash
    mix run priv/repo/seeds.exs
    ```

You can find a video presentation of the project here: [Link to Video Presentation]
