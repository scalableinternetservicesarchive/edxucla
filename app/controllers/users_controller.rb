class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]


  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @isCorrectUser=current_user?(@user)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to edxUCLA!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def edit_profile
    @user = User.find(current_user)
    @education_users = EducationUser.where(user_id: current_user.id)
    @course_users = CourseUser.where(user_id: current_user.id)
    #@educations = Education.where(id: @education_users.education_id)
    num_education_users = @education_users.count
    educations = []
    course_users = []
    i = 0

    while i < @education_users.count
      educations[i] = Education.find_by(id: @education_users[i].education_id)
        course_users[i] = @course_users.where(education_id: @education_users[i].education_id)
      i += 1
    end
    @educations = educations
    @course_users = course_users

    @num_course_users = @course_users.count
    @num_educations = @educations.count
    @counter = 0

    @new_education = Education.new
  end

  def update_profile
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit_profile'
    end
  end

  # add education to Education table if new
  # link user and education in EducationUser table
  def add_education
    education_params = params.require(:education).permit(:name, :alias)

    if !education_params[:name].blank? && !education_params[:alias].blank?

      @education = Education.find_by(name: education_params[:name], alias: education_params[:alias])

      if @education.blank?
        @education = Education.create(name: education_params[:name], alias: education_params[:alias])
      end

      @education_user = EducationUser.find_by(user_id: current_user.id, education_id: @education.id)

      if @education_user.blank?
        @education_user = EducationUser.create(user_id: current_user.id, education_id: @education.id)
      else
        flash[:success] = "Education already added"
        redirect_to User.find(current_user)
        return
      end

      flash[:success] = "Education added"
      redirect_to User.find(current_user)
    end
  end

  def edit_education
    @user = User.find(current_user)
    @education_users = EducationUser.where(user_id: current_user.id)

    eid = params[:eid]
    @@eid = eid

    @education = Education.find_by(id: eid)
    @@e_alias = @education.alias

    @course_users = CourseUser.where(user_id: current_user.id).where(education_id: eid)

    @counter = 0
    @new_course_user = CourseUser.new
  end

  def update_education
    e_alias=@@e_alias
    eid=@@eid

    course_user_params = params.require(:course_user).permit(:course_name, :course_alias, :department)
    course_user_params[:user_id] = current_user.id
    course_user_params[:education_alias] = e_alias
    course_user_params[:education_id] = eid

    if !course_user_params[:course_name].blank?
      @course = Course.find_by(education_id: eid, name: course_user_params[:course_name])

      if @course.blank?
        @course = Course.create(education_id: e_alias, name: course_user_params[:name], alias: course_user_params[:course_alias])
      end

      course_user_params[:course_id] = @course.id
      @course_user = CourseUser.create(course_user_params)

      flash[:success] = "Course added"
      redirect_to User.find(current_user)
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end