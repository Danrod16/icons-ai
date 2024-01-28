class CheckoutsController < ApplicationController
   def show
        current_user.set_payment_processor :stripe
        product_prod = "price_1OdaIZFhsXVBkTNCC7tVmpNZ"
        product_test = "price_1ObpKFFhsXVBkTNCFnekdA0R"
        @checkout_session = current_user.payment_processor.checkout(
            mode: "payment",
            line_items: product_prod
        )
    end     

end
