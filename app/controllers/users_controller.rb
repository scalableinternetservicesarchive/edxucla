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
  end

  def update_profile
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
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