class AddNameToRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :name, :string
  end
end
