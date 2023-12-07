class AddStyleToRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :requests, :style, null: false, foreign_key: true
  end
end
