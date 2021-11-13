class Exam < ApplicationRecord
  belongs_to :college
  belongs_to :exam_window
  validates_presence_of :college_id
  validates_presence_of :exam_window_id
  has_many :user_exams
  has_many :users, through: :user_exams

  def self.assign_exam_to_user(user_params, exam_params)
    user = User.find_or_create_by!(user_params)
    college = College.find(exam_params[:college_id])
    exam = college.exams.find(exam_params[:exam_id])

    raise ActionController::BadRequest.new('Start time is not within the exam window') unless exam.exam_window.valid_start_time?(exam_params[:start_time].to_datetime)
    exam.users << user
    exam
  end
end
