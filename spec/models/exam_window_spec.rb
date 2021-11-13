require 'rails_helper'

RSpec.describe ExamWindow, type: :model do
  describe 'valid_start_time?' do
    let(:exam_window) { ExamWindow.new(start_time: Time.now - 1.hour, end_time: Time.now + 1.hour) }

    context 'when the test_time is within the range of the exam window\'s start and end times' do
      it 'returns true' do
        expect(exam_window.valid_start_time?(Time.now)).to eq true
      end
    end

    context 'when the test_time is after the exam window\'s range' do
      it 'returns false' do
        expect(exam_window.valid_start_time?(Time.now + 2.hour)).to eq false
      end
    end

    context 'when the test_time is before the exam window\'s range' do
      it 'returns false' do
        expect(exam_window.valid_start_time?(Time.now - 2.hour)).to eq false
      end
    end
  end
end
