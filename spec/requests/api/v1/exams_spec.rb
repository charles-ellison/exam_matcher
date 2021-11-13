require 'rails_helper'

RSpec.describe Api::V1::ExamsController, type: :request do
  describe 'GET /show' do
    let(:college) { College.create(name: 'college name') }
    let(:exam) { college.exams.create(start_window: Time.now - 1.hour, end_window: Time.now + 1.hour) }
    let(:first_name) { 'bob' }
    let(:last_name) { 'jones' }
    let(:phone_number) { '0123456789' }
    let(:start_time) { Time.now }
    
    context 'when the request is valid' do
      it 'returns the exam with a 200 status' do
        get "/api/v1/exams/#{exam.id}?first_name=#{first_name}&last_name=#{last_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"
        expect(response.status).to eq 200
      end
    end

    context 'When the phone number has invalid characters' do
      let(:bad_phone_number) { '(123)456-7897' }

      it 'raises an bad request exception with a 400 status code' do
        get "/api/v1/exams/#{exam.id}?first_name=#{first_name}&last_name=#{last_name}&phone_number=#{bad_phone_number}&college_id=#{college.id}&start_time=#{start_time}"

        expect(response.status).to eq 400
      end
    end

    context 'When the first_name param is missing' do
      it 'raises a bad request exception with a 400 status code' do
        get "/api/v1/exams/#{exam.id}?last_name=#{last_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"

        expect(response.status).to eq 400
      end
    end
    
    context 'When the last_name param is missing' do
      it 'raises a bad request exception with a 400 status code' do
        get "/api/v1/exams/#{exam.id}?first_name=#{first_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"

        expect(response.status).to eq 400
      end
    end
    
    context 'When an exam is not found' do
      it 'raises an exception with a 400 status code' do
        get "/api/v1/exams/0?first_name=#{first_name}&last_name=#{last_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"

        expect(response.status).to eq 400
      end
    end

    context 'When an exam does not belong to the college' do
      let(:other_college) { College.create(name: 'other college') }
      
      it 'raises an exception with a 400 status code' do
        get "/api/v1/exams/#{exam.id}?first_name=#{first_name}&last_name=#{last_name}&phone_number=#{phone_number}&college_id=#{other_college.id}&start_time=#{start_time}"

        expect(response.status).to eq 400
      end
    end

    context 'when a user fails to be found or created' do
      it 'raises an exception with a 400 status code' do
        get "/api/v1/exams/#{exam.id}?first_name=&last_name=#{last_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"
        
        expect(response.status).to eq 400
      end
    end

    context 'When a requested start_time is before an exam\'s start window' do
      let(:exam_with_later_time) { college.exams.create(start_window: Time.now + 1.hour, end_window: Time.now + 2.hour) }
      
      it 'raises an exception with a 400 status code' do
        get "/api/v1/exams/#{exam_with_later_time.id}?first_name=''&last_name=#{last_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"
        
        expect(response.status).to eq 400
      end
    end
    
    context 'When a requested start_time is after an exam\'s end window' do
      let(:exam_with_later_time) { college.exams.create(start_window: Time.now - 3.hour, end_window: Time.now - 1.hour) }
      
      it 'raises an exception with a 400 status code' do
        get "/api/v1/exams/#{exam_with_later_time.id}?first_name=''&last_name=#{last_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"
        
        expect(response.status).to eq 400
      end
    end
  end
end