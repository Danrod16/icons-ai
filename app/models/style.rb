class Style < ApplicationRecord
    has_many :requests, dependent: :nullify
    validates :name, presence: true, uniqueness: true
end
