# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

begin
  seed_start = SeedState.create(status: true)
rescue ActiveRecord::RecordNotUnique
  if SeedState.exists?(status: false)
    p '===Seeding is already done.'
  else
    p '===Seeding is being executed by another instance.'
  end
else
  p '===This is the only one instance that is seeding the data...'

  #number of users
  num = 1000

  education_array = [
    ["university of california los angeles", "ucla"],
    ["university of california berkeley", "cal"],
    ["university of california irvine", "uci"],
    ["university of california san diego", "ucsd"],
    ["university of california davis", "ucd"],
    ["university of california riverside", "ucr"],
    ["university of california santa barbara", "ucsb"],
    ["university of california merced", "ucm"],
    ["university of california san francisco", "ucf"],
    ["university of california santa cruz", "ucsc"]
  ]

  #course_array = [
  #  ["introduction to computer science 1","cs31"],
  #  ["introduction to computer science 2","cs32"],
  #  ["operating system principles","cs111"],
  #  ["programming languages","cs131"],
  #  ["compiler construction","cs132"],
  #  ["introduction to computer security","cs136"],
  #  ["database systems","cs143"],
  #  ["fundamentals of artificial intelligence","cs161"],
  #  ["introduction to cryptography","183"],
  #  ["scalable internet services","188"]
  #]

  course_array = []

  1000.times do |a|
    t_course = [('a'..'z').to_a.shuffle[0,13].join , "ge#{(a % 1000) + 1 }" ]
    course_array[a] = t_course
  end

  #Create Educations
  education_array.each do |education_elem|
    education = Education.create(
      name: education_elem[0],
      alias: education_elem[1]
      )

    #Create Courses
    course_array.each do |course|
      Course.create(
      education_id: education.id,
      department: "general education",
      name: course[0],
      alias: course[1]
      )
    end

  end

  convo_id = 0
  course_counter = 0

  num.times do |n|

    # Create Users
    name  = "user_#{n + 1}"
    email = "user_#{n + 1}@example.com"
    password = "password"
    user = User.create(
      name:  name,
      email: email,
      password:              password,
      password_confirmation: password
    )

    #Create EducationUsers
    education_it = n % 10

    if education_it == 0
      course_counter = course_counter + 1
      course_counter = course_counter % 1000
    end

    EducationUser.create(
      user_id: user.id,
      education_id: education_it + 1
    )

    #Create CourseUsers
    CourseUser.create(
      user_id: user.id,
      course_id: course_counter,
      education_id: education_it + 1,
      education_alias: education_array[education_it][1],
      course_name: course_array[course_counter-1][0],
      course_alias: course_array[course_counter-1][1]
    )

    #Create UserRequests
    if n % 2 == 0
      UserRequest.create(
        request_type: "tutor_request",
        sender: user.id,
        receiver: ((n + 2) % num) + 1,
        course_id: 0
      )
    else
      UserRequest.create(
        request_type: "student_request",
        sender: user.id,
        receiver: ((n + 2) % num) + 1,
        course_id: 0
      )
    end

    #Create Conversations
    if n % 2 == 0
      conversation = Conversation.create(
        user_one: user.id,
        user_two: (user.id % num ) + 1
      )
      convo_id = conversation.id
    end

    #Create UserMessages
    if n % 2 == 0
      UserMessage.create(
        message: Faker::Hipster.sentence,
        sender: user.id,
        receiver: (user.id % num ) + 1,
        conversation_id: convo_id
      )
    end

    #Create TutoringSessions
    if n % 2 == 0
      TutoringSession.create(
        tutor: user.id,
        student: (user.id % num ) + 1,
        course_id: 0,
        status: "active"
      )
    end
  end
   seed_done = SeedState.create(status: false)
   p '===Seeding is done.'
end