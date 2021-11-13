require 'rails_helper'

RSpec.describe Exam, type: :model do
  describe 'validations' do
    context 'when it has a college id and an window_exam_id' do
      it 'is valid' do
        college = College.create
        exam_window = ExamWindow.create(start_time: Time.now, end_time: Time.now)

        exam = Exam.new(college_id: college.id, exam_window_id: exam_window.id)
        expect(exam.valid?).to eq true
      end
    end

    context 'when it does not have a college id' do
      it 'is not valid' do
        exam_window = ExamWindow.create(start_time: Time.now, end_time: Time.now)

        exam = Exam.new(exam_window_id: exam_window.id)

        expect(exam.valid?).to eq false
      end
    end

    context 'when it does not have an exam_window_id' do
      it 'is not valid' do
        college = College.create

        exam = Exam.new(college_id: college.id)
        expect(exam.valid?).to eq false
      end
    end
  end
end
