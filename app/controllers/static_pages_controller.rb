class StaticPagesController < ApplicationController
  def home
    if logged_in?
      user = current_user.id;
      @sessions_tutor = TutoringSession.where('tutor = :tutor AND status = "active"', tutor: "#{user}")
      @sessions_student = TutoringSession.where('student = :student AND status = "active"', student: "#{user}")

      @students = []
      @conversations_tutor = []
      i = 0
      while i < @sessions_tutor.size
        @students[i] = User.find(@sessions_tutor[i].student)
        @conversations_tutor[i] = Conversation.where('user_one = :sender and user_two = :receiver or user_one = :receiver and user_two = :sender', sender: user, receiver: @students[i])[0]
        i += 1
      end

      i = 0
      @tutors = []
      @conversations_student = []
      while i < @sessions_student.size
        @tutors[i] = User.find(@sessions_student[i].tutor)
        @conversations_student[i] = Conversation.where('user_one = :sender and user_two = :receiver or user_one = :receiver and user_two = :sender', sender: user, receiver: @tutors[i])[0]
        i += 1
      end
    end
  end

  def help
  end
  
  def about
  end

end
