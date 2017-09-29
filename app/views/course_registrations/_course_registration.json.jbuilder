json.extract! course_registration, :id, :first_name, :last_name, :email, :contact, :course_id, :created_at, :updated_at
json.url course_registration_url(course_registration, format: :json)
