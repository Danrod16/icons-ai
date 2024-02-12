class CheckoutsController < ApplicationController
   def show
        current_user.set_payment_processor :stripe
        product = Rails.env.production? ? "price_1OdaIZFhsXVBkTNCC7tVmpNZ" : "price_1ObpKFFhsXVBkTNCFnekdA0R"
        @checkout_session = current_user.payment_processor.checkout(
            mode: "payment",
            line_items: product,
            success_url: root_path,
            cancel_url: root_path
        )
    end     

end
