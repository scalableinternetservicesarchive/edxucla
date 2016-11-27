class UserRequestController < ApplicationController
  def new
    request_params = params.permit(:student, :tutor, :type, :course, :message)
    curr_user = current_user

    if request_params[:course].nil?
      request_params[:course] = 0
    end

    if request_params[:type] == "student_request"
      @user_request = UserRequest.create(request_type: request_params[:type], sender: request_params[:tutor], receiver: request_params[:student], course_id: request_params[:course])

      unless request_params[:message].empty?
        conversation_params = {}
        conversation_params[:user_one] = request_params[:tutor]
        conversation_params[:user_two] = request_params[:student]

        conversation = Conversation.safe_where_or_create_by(conversation_params)

        @user_message = UserMessage.create(message: request_params[:message], sender: request_params[:tutor], receiver: request_params[:student], conversation_id: conversation.id)
      end
    elsif request_params[:type] == "tutor_request"
      @user_request = UserRequest.create(request_type: request_params[:type], sender: request_params[:student], receiver: request_params[:tutor], course_id: request_params[:course])

      unless request_params[:message].empty?
        conversation_params = {}
        conversation_params[:user_one] = request_params[:tutor]
        conversation_params[:user_two] = request_params[:student]

        conversation = Conversation.safe_where_or_create_by(conversation_params)

        @user_message = UserMessage.create(message: request_params[:message], sender: request_params[:tutor], receiver: request_params[:student])
      end
    end

    flash[:success] = "Request sent"
    if request_params[:type] == "student_request"
      redirect_to User.find(request_params[:student])
    elsif request_params[:type] == "tutor_request"
      redirect_to User.find(request_params[:tutor])
    end
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
    @curr_user_id = current_user.id
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
    @curr_user_id = current_user.id
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
    session_params[:status] = "active"

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
