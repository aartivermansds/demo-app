class AddStripeProductIdToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :stripe_product_id, :string
  end
end
