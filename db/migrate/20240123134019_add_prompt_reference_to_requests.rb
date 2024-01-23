class AddPromptReferenceToRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :requests, :prompt, null: false, foreign_key: true
  end
end
