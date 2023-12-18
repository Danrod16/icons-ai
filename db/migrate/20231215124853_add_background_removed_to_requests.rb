class AddBackgroundRemovedToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :bg_removed, :boolean
  end
end
