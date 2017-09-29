class CreateCourseRegistrations < ActiveRecord::Migration
  def change
    create_table :course_registrations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :contact
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
