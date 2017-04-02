json.extract! course, :id, :title, :code, :teacher_id, :quota, :created_at, :updated_at
json.url course_url(course, format: :json)
