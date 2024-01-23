class MyChargeSucceededProcessor
    def call(event)
        pay_charge = event.data.object
        # event.data.object is a Stripe::Charge object to top up the user's wallet
        charge = pay_charge
        # Retrieve the user that owns the wallet
        user = User.find_by(email: charge.customer_email)
        # Retrieve the wallet to top up
        wallet = user.wallet
        # Create a transaction
        Transaction.create(
            user: user,
            wallet: wallet,
            amount: charge.amount / 100,
            transaction_type: "top_up"
        )
        # Update the wallet's balance
        wallet.update(balance: wallet.balance + charge.amount / 100)
    end
end