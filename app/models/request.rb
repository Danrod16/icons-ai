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
         prompt: "#{set_prompt}", size: "1024x1024"
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
    when ""
      "Simple flat monochrome logo of a'#{topic}' for the company '#{name}' in #{color} color."
    when "Vintage"
      "#{topic}. The design should emphasize clean lines, consistent stroke widths, and a minimalist style. It should be both recognizable and simplistic, quintessential of modern web iconography. The only color used in the design should be #{color}, making it versatile for various screen sizes and resolutions. Remember to maintain a lightweight and scalable design to ensure its suitability for various web interface applications"
    when "Neutral"
      " #{topic} in #{color} color without shadows or gradients, on a contrasted background "
    when "Serious"
      " #{topic} in #{color} color without shadows or gradients, on a contrasted background "
    end
  end
end
