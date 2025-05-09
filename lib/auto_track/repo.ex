defmodule AutoTrack.Repo do
  use Ecto.Repo,
    otp_app: :auto_track,
    adapter: Ecto.Adapters.Postgres
end
