class StaticPagesController < ApplicationController
  def home
    if logged_in?
      user = current_user.id;
      @sessions_tutor = TutoringSession.where('tutor = :tutor AND status = "active"', tutor: "#{user}")
      @sessions_student = TutoringSession.where('student = :student AND status = "active"', student: "#{user}")

      @students = []
      i = 0
      while i < @sessions_tutor.count
        @students[i] = User.find(@sessions_tutor[i].student)
        i += 1
      end

      i = 0
      @tutors = []
      while i < @sessions_student.count
        @tutors[i] = User.find(@sessions_student[i].tutor)
        i += 1
      end
    end
  end

  def help
  end
  
  def about
  end

  def chat
  end

  def requests
  end

end
