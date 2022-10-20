class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.references :customer, null: false, foreign_key: true
      t.decimal :total_price

      t.timestamps
    end
  end
end
