class SearchController < ApplicationController
  #skip_before_filter :verify_authenticity_token
  def search
    # TODO: Add input sanitation
    @search_result_type = ""

    if params[:input].nil?
      return
    end

    if params[:type] == "Course" || params[:type] == "Department"
      @search_result_type = "courses"

      if params[:type] == "Course"
        courses = Course.where('name LIKE :search OR alias LIKE :search', search: "%#{params[:input]}%")
      else
        courses = Course.where('department LIKE :search', search: "%#{params[:input]}%")
      end

      courses_array = []
      i = 0

      while i < courses.count
        courses_array[i] = courses[i]
        i += 1
      end

      i = 0
      educations = []

      while i < courses_array.count
        educations[i] = Education.where(id: courses_array[i].education_id)[0]
        i += 1
      end

      @search = courses.paginate(page: params[:page])
      @educations = educations

    elsif params[:type] == "Education"
      @search_result_type = "educations"

      educations = Education.where('name LIKE :search OR alias LIKE :search', search: "%#{params[:input]}%")

    @search = educations.paginate(page: params[:page])

    elsif params[:type] == "User"
      @search_result_type = "users"
      users = User.where('name LIKE :search', search: "%#{params[:input]}%")
      @search = users.paginate(page: params[:page])

    elsif params[:type] == "User-courses"
      @search_result_type = "users"
      course_users = CourseUser.where('course_id LIKE :search', search: "%#{params[:input]}%")

      i = 0
      user_id_array = []

      while i < course_users.count
        user_id_array[i] = course_users[i].user_id
        i += 1
      end

      users = User.where(id: user_id_array)
      @search = users.paginate(page: params[:page])

    elsif params[:type] == "Courses-department"
      @search_result_type = "courses"
      courses = Course.where('department LIKE :search', search: "%#{params[:input]}%")

      i = 0
      educations = []

      while i < courses.count
        educations[i] = Education.where(id: courses[i].education_id)[0]
        i += 1
      end

      @educations = educations
      @search = courses.paginate(page: params[:page])

    elsif params[:type] == "Courses-education"
      @search_result_type = "courses"
      courses = Course.where('education_id LIKE :search', search: "%#{params[:input]}%")

      i = 0
      educations = []

      while i < courses.count
        educations[i] = Education.where(id: courses[i].education_id)[0]
        i += 1
      end

      @educations = educations
      @search = courses.paginate(page: params[:page])
    end

  end
end
