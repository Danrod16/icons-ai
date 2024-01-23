Rails.configuration.stripe = {
    private_key: ENV['STRIPE_PUBLIC_KEY'],
    private_key: ENV['STRIPE_PRIVATE_KEY'],
    signing_secret:  ENV['STRIPE_SIGNING_SECRET']
  }
  
Stripe.api_key = Rails.configuration.stripe[:private_key]