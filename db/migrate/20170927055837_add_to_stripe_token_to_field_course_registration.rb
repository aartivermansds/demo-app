class AddToStripeTokenToFieldCourseRegistration < ActiveRecord::Migration
  def change
    add_column :course_registrations, :stripe_token, :string
    add_column :course_registrations, :stripe_token_type, :string
  end
end
