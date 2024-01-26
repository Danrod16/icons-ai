class Wallet < ApplicationRecord
    belongs_to :user

    def positive_balance?
        balance > 0
    end

    def negative_balance?
        balance < 0
    end
end
