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
  end

  private

  def set_photo
    begin
      client = OpenAI::Client.new
      response = client.images.generate(parameters: {
         prompt: "You are a graphic designer, #{topic}. The logo should be a unique drawing, do not include any lettering and do not show any realistic photo detail shading", size: "1024x1024", model: "dall-e-3", num_images: 1
        })
        puts response
        url = response["data"][0]["url"]
        file = URI.open(url)
        photo.purge if photo.attached?
        photo.attach(io: file, filename: "#{topic.split(" ").join("-")}.jpg", content_type: "image/png")
        return photo
      rescue Faraday::Error => e
        raise "Got a Faraday error: #{e}"
      end
  end
end
