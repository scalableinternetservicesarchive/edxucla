class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def search
    # TODO: Add input sanitation
    @search_type = 0

    if params[:input].nil?
      @search_type = -1
      return
    end

    if params[:type] == "Course" || params[:type] == "Department"
      @search_type = 1

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
      @search_type = 2

      educations = Education.where('name LIKE :search OR alias LIKE :search', search: "%#{params[:input]}%")

    @search = educations.paginate(page: params[:page])

    elsif params[:type] == "User"
      @search_type = 3
      users = User.where('name LIKE :search', search: "%#{params[:input]}%")
      @search = users.paginate(page: params[:page])
    end

  end
end
