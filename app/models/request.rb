require 'remove_bg'
require 'open-uri'
class Request < ApplicationRecord
  belongs_to :user
  belongs_to :prompt
  has_one_attached :photo
  after_create :set_photo
  validates :topic, presence: true

  def background_removed!
    update(bg_removed: true)
    transaction = Transaction.create(
        user: user,
        wallet: user.wallet,
        amount: 1
    )
    user.wallet.update(balance: user.wallet.balance - transaction.amount)
  end

  private

  def set_photo
    begin
      client = OpenAI::Client.new
      response = client.images.generate(parameters: {
         prompt: "You are a graphic designer, #{topic}. The logo should be a unique drawing and not on a mochup of any kind, it should be simple enough that it can be turned into a 16x16 favicon and should not include any lettering and do not show any realistic photo detail shading", size: "1024x1024", model: "dall-e-3", num_images: 1
        })
        puts response
        url = response["data"][0]["url"]
        file = URI.open(url)
        photo.purge if photo.attached?
        photo.attach(io: file, filename: "#{topic.split(" ").join("-")}.jpg", content_type: "image/png")
        transaction = Transaction.create(
            user: self.user,
            wallet: self.user.wallet,
            amount: 1
        )
        self.user.wallet.update(balance: self.user.wallet.balance - transaction.amount)
        return photo
      rescue Faraday::Error => e
        raise "Got a Faraday error: #{e}"
      end
  end
end
