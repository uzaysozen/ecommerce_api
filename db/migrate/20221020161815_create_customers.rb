class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :email
      t.string :name
      t.string :surname
      t.string :phone_number

      t.timestamps
    end
  end
end
