require 'remove_bg'
require 'open-uri'
class Request < ApplicationRecord
  belongs_to :user
  belongs_to :style
  has_one_attached :photo
  after_create :set_photo
  validates :topic, presence: true
  validates :color, presence: true

  def background_removed!
    update(bg_removed: true)
  end

  private

  def set_photo
    begin
      client = OpenAI::Client.new
      response = client.images.generate(parameters: {
        prompt: "I want you to act as an illustartor for web interface icons. #{set_prompt}", size: "1024x1024", model: "dall-e-3"
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

  def set_prompt
    case style.name
    when "Metallic 3D"
      "An Icon of a #{topic} in metallic #{color} iridescent material, 3D render isometric perspective rendered in Cinema 4D on a contrasted background"
    when "Minimal"
      "Create a modern icon design representing #{topic}. The design should emphasize clean lines, consistent stroke widths, and a minimalist style. It should be both recognizable and simplistic, quintessential of modern web iconography. The only color used in the design should be #{color}, making it versatile for various screen sizes and resolutions. Remember to maintain a lightweight and scalable design to ensure its suitability for various web interface applications"
    when "Flat"
      "A simple icon by the noun project of the outline of a #{topic} in #{color} color without shadows or gradients, on a contrasted background "
    end
  end
end
