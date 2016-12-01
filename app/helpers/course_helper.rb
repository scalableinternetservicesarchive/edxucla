module CourseHelper
  def cache_key_for_course_search(course)
    "course-#{course.id}-#{course.updated_at}"
  end
end
