require 'rails_helper'

RSpec.describe Api::V1::ExamsController, type: :request do
  describe 'GET /show' do
    let(:college) { College.create(name: 'college name') }
    let(:exam) { college.exams.create }
    
    context 'when the request is valid' do
      let(:first_name) { 'bob' }
      let(:last_name) { 'jones' }
      let(:phone_number) { '0123456789' }
      let(:college_id) { 2 }
      let(:start_time) { Time.now.to_s }

      it 'returns the exam with a 200 status' do
        get "/api/v1/exams/#{exam.id}?first_name=#{first_name}&last_name=#{last_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"
        expect(response.status).to eq 200
      end
    end

    context 'When the phone number has invalid characters' do
      let(:first_name) { 'bob' }
      let(:last_name) { 'jones' }
      let(:phone_number) { '(123)456-7897' }
      let(:college_id) { 2 }
      let(:start_time) { Time.now.to_s }

      it 'raises an bad request exception with a 400 status code' do
        get "/api/v1/exams/#{exam.id}?first_name=#{first_name}&last_name=#{last_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"

        expect(response.status).to eq 400
      end
    end

    context 'When the first_name param is missing' do
      let(:last_name) { 'jones' }
      let(:phone_number) { '0123456789' }
      let(:college_id) { 2 }
      let(:start_time) { Time.now.to_s }

      it 'raises a bad request exception with a 400 status code' do
        get "/api/v1/exams/#{exam.id}?last_name=#{last_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"

        expect(response.status).to eq 400
      end
    end
    
    context 'When the last_name param is missing' do
      let(:first_name) { 'bob' }
      let(:phone_number) { '0123456789' }
      let(:college_id) { 2 }
      let(:start_time) { Time.now.to_s }

      it 'raises a bad request exception with a 400 status code' do
        get "/api/v1/exams/#{exam.id}?first_name=#{first_name}&phone_number=#{phone_number}&college_id=#{college.id}&start_time=#{start_time}"

        expect(response.status).to eq 400
      end
    end
    
    context 'When an exam is not found' do
      let(:first_name) { 'bob' }
      let(:last_name) { 'jones' }
      let(:phone_number) { '0123456789' }
      let(:college_id) { 2 }
      let(:start_time) { Time.now.to_s }

      it 'raises an exception with a 400 status code' do
        get "/api/v1/exams/0?first_name=#{first_name}&phone_number=#{phone_number}&college_id=#{college_id}&start_time=#{start_time}"

        expect(response.status).to eq 400
      end
    end

    # context 'When an exam does not belong to the college' do
    #   it 'raises an exception with a 400 status code' do
    #   end
    # end

    # context 'when a user fails to be found or created' do
    #   it 'raises an exception with a 400 status code' do
    #   end
    # end

    # context 'When a requested start_time does not fall with in an exam\'s time window' do
    #   it 'raises an exception with a 400 status code' do
    #   end
    # end

    # context 'When the request data is valid and sanitized, the college exists and the exam belongs to the college, a user is successfully found or created, and the start time of the exam is within the exam window' do
    #   it 'returns a 200 status' do
    #   end
      
    #   it 'returns the exam' do
    #   end
    # end
  end
end