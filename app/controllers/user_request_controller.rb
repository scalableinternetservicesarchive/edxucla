class UserRequestController < ApplicationController
  def new
    request_params = params.permit(:user, :type, :course, :message)
    curr_user = current_user

    if request_params[:course].nil?
      request_params[:course] = 0
    end

    @user_request = UserRequest.create(request_type: request_params[:type], sender: curr_user.id, receiver: request_params[:user], course_id: request_params[:course])

    unless request_params[:message].empty?
      @user_message = UserMessage.create(message: request_params[:message], sender: curr_user.id, receiver: request_params[:user])
    end

    flash[:success] = "Request sent"
    redirect_to User.find(request_params[:user])
  end

  def show_tutor
    if params[:user].nil?
      return
    end

    @user = User.where(id: params[:user])[0]
    @education_users = EducationUser.where(user_id: @user.id)
    @course_users = CourseUser.where(user_id: @user.id)

    num_education_users = @education_users.count
    educations = []
    course_users = []
    i = 0
    course_strings = []

    while i < @education_users.count
      educations[i] = Education.find_by(id: @education_users[i].education_id)
        course_users[i] = @course_users.where(education_id: @education_users[i].education_id)

        j = 0
        course_strings[i] = []
        while j < course_users[i].count
          course_strings[i][j]=course_users[i][j].course_name.to_s + " (" + educations[i].alias + "-" + course_users[i][j].course_alias.to_s + ")"
          j += 1
        end
      i += 1
    end
    @educations = educations
    @course_users = course_users
    @course_strings = course_strings

    @num_course_users = @course_users.count
    @num_educations = @educations.count
    @counter = 0
  end

  def show_student
    if params[:user].nil?
      return
    end

    @user = User.where(id: params[:user])[0]
    @education_users = EducationUser.where(user_id: @user.id)
    @course_users = CourseUser.where(user_id: @user.id)

    num_education_users = @education_users.count
    educations = []
    course_users = []
    i = 0
    course_strings = []

    while i < @education_users.count
      educations[i] = Education.find_by(id: @education_users[i].education_id)
        course_users[i] = @course_users.where(education_id: @education_users[i].education_id)

        j = 0
        course_strings[i] = []
        while j < course_users[i].count
          course_strings[i][j]=course_users[i][j].course_name.to_s + " (" + educations[i].alias + "-" + course_users[i][j].course_alias.to_s + ")"
          j += 1
        end
      i += 1
    end
    @educations = educations
    @course_users = course_users
    @course_strings = course_strings

    @num_course_users = @course_users.count
    @num_educations = @educations.count
    @counter = 0
  end

  def requests
  end

end
