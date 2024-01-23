ActiveSupport.on_load(:pay) do
    Pay::Webhooks.delegator.subscribe "stripe.charge.succeeded", MyChargeSucceededProcessor.new
end