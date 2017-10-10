class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :stripe_customer_id
      t.string :stripe_customer_email

      t.timestamps null: false
    end
  end
end
