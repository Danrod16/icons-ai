class Prompt < ApplicationRecord
    belongs_to :user
    has_many :requests, dependent: :destroy
    validates :description, presence: true
    validates :description, length: { minimum: 10 }
    validates :description, length: { maximum: 1000 }
    after_create :call_prompt

    private

    def call_prompt
        begin
        client = OpenAI::Client.new(request_timeout: 30)
        response = client.chat(
            parameters: {
                model: "gpt-4",
                messages: [{ role: "user", content: "Please give me 5 different detailed prompts that describe different logo designs that could be used for asking Dall-e 2 model to design a logo based on the following description: #{description}. Each prompt should recommend different visual elements and colors proposition with its justification and should follow this structure: Create a simple [Style type] logo for a [industry] brand with a [description of the elements and what it symbolizes] and [colors or color shades description] on a white background. Please seperate each prompt with a $ sign and don't use numbered list"}], # Required.
                temperature: 0.1,
            })
        self.update(prompt_response: response.dig("choices", 0, "message", "content"))
        transaction = Transaction.create(
            user: self.user,
            wallet: self.user.wallet,
            amount: 1
        )
        self.user.wallet.update(balance: self.user.wallet.balance - transaction.amount)
        rescue Faraday::Error => e
            raise "Got a Faraday error: #{e}"
        end
    end
end
