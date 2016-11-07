class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def search
    # TODO: Add input sanitation
    @search_exists = true

    if params[:input].nil?
      @search_exists = false
      return
    end

    if params[:type]=="Course"
      courses = Course.where('name LIKE :search OR alias LIKE :search', search: "%#{params[:input]}%")

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
    end

    @search = courses.paginate(page: params[:page])
    @educations = educations

  end
end
