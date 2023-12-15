require 'remove_bg'
require 'open-uri'
class Request < ApplicationRecord
  belongs_to :user
  belongs_to :style
  has_one_attached :photo
  after_create :set_photo

  private

  def set_photo
    client = OpenAI::Client.new
    response = client.images.generate(parameters: {
      prompt: "I want you to act as a graphic designer. #{set_prompt}", size: "1024x1024", model: "dall-e-3"
    })

    # url = "https://oaidalleapiprodscus.blob.core.windows.net/private/org-DQ35AwkaQ3eckiMNcKAyNehh/user-X6YuUbvKmXXgUye6pHZlAVVZ/img-99ItqxZHNNgL93RgHL6cxcEE.png?st=2023-12-14T11%3A48%3A34Z&se=2023-12-14T13%3A48%3A34Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-12-14T10%3A55%3A26Z&ske=2023-12-15T10%3A55%3A26Z&sks=b&skv=2021-08-06&sig=ymNVeJT6kqgAwg5dWln1oKO8GHtFnNN98s9YSfNf14I%3D"
    puts response
    url = response["data"][0]["url"]
    image = RemoveBg.from_url(url, size: "regular", type: "auto", raw: true, api_key: ENV["REMOVE_BG_API_KEY"])
    image_path = "#{Rails.root}/app/assets/images/user_images/#{id}-#{topic}.png"
    image.save(image_path)      
    photo.purge if photo.attached?
    photo.attach(io: File.open(image_path), filename: "#{topic.split(" ").join("-")}.jpg", content_type: "image/png")
    File.delete(image_path)
    return photo
  end

  def set_prompt
    case style.name
    when "metallic 3D"
      "An Icon of a #{topic} in metallic #{color} iridescent material, 3D render isometric perspective rendered in Cinema 4D on a contrasted background"
    when "Hand drawn"
      "A simple Icon of the outline of a #{topic} in #{color} stroke, styled like the noun project icons on a contrasted background"
    when "Flat"
      "A simple icon of the outline of a #{topic} in #{color} color without shadows or gradients, on a contrasted background "
    end
  end
end
