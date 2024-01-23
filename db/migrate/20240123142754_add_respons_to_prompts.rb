class AddResponsToPrompts < ActiveRecord::Migration[7.0]
  def change
    add_column :prompts, :prompt_response, :text
  end
end
