Rails.configuration.stripe = {
  publishable_key: ENV['pk_test_51Q6yj3GLFdlhiZiicrlQIHCAzxtxOxgcCgEY9d4ZkZ7cU3YwLNvX9gDI6ZU51wpE0OVzVXtCwO6hs6h0AcfRing500vcVafLkz'],
  secret_key: ENV['sk_test_51Q6yj3GLFdlhiZiiA4Lmsjuh6OeP5BwgMiMUCNyYmExcE105YaZA6wG0njzFKZIbBKTWTV7fZMETee13V96FTW2P00nh7dk3KN']
}
Stripe.api_key = ENV['sk_test_51Q6yj3GLFdlhiZiiA4Lmsjuh6OeP5BwgMiMUCNyYmExcE105YaZA6wG0njzFKZIbBKTWTV7fZMETee13V96FTW2P00nh7dk3KN']