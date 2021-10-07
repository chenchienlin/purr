import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :purr, PurrWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8FLrT83RtILsxYmvcQdLQVPjBstA2dcnGbZ7Ad/60BEdQlJ+7RvjJIFFnABuI8Ly",
  server: false

# In test we don't send emails.
config :purr, Purr.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
