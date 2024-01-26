class MyChargeSucceededProcessor
    def call(event)
        pay_charge = Pay::Stripe::Charge.sync(event.data.object.id, stripe_account: event.try(:account))
        # event.data.object is a Stripe::Charge object to top up the user's wallet
        charge = pay_charge
        # Retrieve the user that owns the wallet
        user = User.find_by(id: charge.customer_id)
        # Retrieve the wallet to top up
        wallet = user.wallet
        # Create a transaction
        transaction = Transaction.create(
            user: user,
            wallet: wallet,
            amount: 15
        )
        # Update the wallet's balance
        wallet.update(balance: wallet.balance + transaction.amount)
    end
end