class CheckoutsController < ApplicationController
   def show
        current_user.set_payment_processor :stripe

        @checkout_session = current_user.payment_processor.checkout(
            mode: "payment",
            line_items: "price_1ObpKFFhsXVBkTNCFnekdA0R"
        )
    end     

end
