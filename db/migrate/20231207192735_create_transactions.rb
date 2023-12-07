class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :wallet, null: false, foreign_key: true
      t.float :amount, default: 0.0
      t.boolean :paid, default: false


      t.timestamps
    end
  end
end
