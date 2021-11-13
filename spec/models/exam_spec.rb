require 'rails_helper'

RSpec.describe Exam, type: :model do
  describe 'validations' do
    context 'when it has a college id' do
      it 'is valid' do
        college = College.create
        exam = college.exams.new
        expect(exam.valid?).to eq true
      end
    end

    context 'when it does not have a college id' do
      it 'is not valid' do
        exam = Exam.new
        expect(exam.valid?).to eq false
      end
    end
  end
end
