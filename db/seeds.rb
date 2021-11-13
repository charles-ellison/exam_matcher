college = College.create(name: Faker::Name.name)
exam_window = ExamWindow.create(start_time: Time.now - 1.hour, end_time: Time.now + 4.hours)
Exam.create(college_id: college.id, exam_window_id: exam_window.id)
