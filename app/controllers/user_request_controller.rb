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
    user = current_user
    @user_request = UserRequest.where(receiver: user.id)

    i = 0
    users = []
    courses = []
    educations = []

    while i < @user_request.count
      users[i] = User.where(id: @user_request[i][:sender])
      courses[i] = Course.where(id: @user_request[i][:course_id])

      if courses[i][0].nil?
        educations[i] = nil
      else
        educations[i] = Education.where(id: courses[i][0][:education_id])
      end
      i += 1
    end

    @users = users
    @courses = courses
    @educations = educations
    @user_request = @user_request.paginate(page: params[:page])
  end

  def accept_request
    request_id = params[:request_id]

    session_params = params.permit(:tutor, :student, :course_id)
    request = UserRequest.find(request_id)

    tutoring_session = TutoringSession.create(session_params)
    request.destroy

    flash[:success] = "Request Accepted"
    redirect_to requests_path
  end

  def decline_request
    request_id = params[:request_id]
    request = UserRequest.find(request_id)
    request.destroy

    flash[:success] = "Request Declined"
    redirect_to requests_path
  end

end
