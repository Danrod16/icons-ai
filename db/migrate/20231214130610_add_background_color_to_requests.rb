class AddBackgroundColorToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :background_color, :string
  end
end
