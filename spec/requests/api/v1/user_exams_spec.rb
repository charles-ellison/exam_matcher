require 'rails_helper'

RSpec.describe Api::V1::UserExamsController, type: :request do
  describe 'POST /create' do
    let(:college) { College.create(name: 'college name') }
    let(:exam_window) { ExamWindow.create(start_time: Time.now - 1.hour, end_time: Time.now + 1.hour) }
    let(:exam) { Exam.create(college_id: college.id, exam_window_id: exam_window.id) }

    let(:first_name) { 'bob' }
    let(:last_name) { 'jones' }
    let(:phone_number) { '0123456789' }
    let(:start_time) { Time.now }

    let(:params) {
      {
        first_name: first_name,
        last_name: last_name,
        phone_number: phone_number,
        start_time: start_time,
        college_id: college.id,
        exam_id: exam.id
      }
    }

    context 'when the request is valid' do
      it 'has a 200 status' do
        post api_v1_user_exams_path(params: params)
        expect(response.status).to eq 200
      end

      it 'creates an api request record' do
        expect { 
          post api_v1_user_exams_path(params: params)
        }.to change { ApiRequest.count }.by(1)
      end

      it 'has the correct info on the api request record' do
        post api_v1_user_exams_path(params: params)

        expected = ApiRequest.last

        expect(expected.exam_id).to eq exam.id
        expect(expected.status).to eq 'success'
      end

      it 'returns the exam' do
        post api_v1_user_exams_path(params: params)

        parsed_response = JSON.parse(response.body).deep_symbolize_keys

        expect(parsed_response[:college_id]).to eq college.id
        expect(parsed_response[:exam_window_id]).to eq exam_window.id
      end
    end

    context 'when the request is invalid' do
      it 'creates an api request record' do
        expect { 
          post api_v1_user_exams_path(params: {})
        }.to change { ApiRequest.count }.by(1)
      end

      it 'has the correct info on the api request record' do
        post api_v1_user_exams_path(params: {})

        expected = ApiRequest.last

        expect(expected.exam_id).to be_nil
        expect(expected.status).to eq 'failed'
        expect(expected.message).to eq 'ActionController::BadRequest: Invalid parameters'
      end

      context 'when the phone number has invalid characters' do
        let(:bad_phone_number) { '(123)456-7897' }
        let(:bad_phone_number_params) { params.clone }

        before do
          bad_phone_number_params[:phone_number] = bad_phone_number
        end

        it 'has a 400 status code' do
          post api_v1_user_exams_path(params: bad_phone_number_params)

          expect(response.status).to eq 400
        end

        it 'returns the correct error object' do
          post api_v1_user_exams_path(params: bad_phone_number_params)

          parsed_response = JSON.parse(response.body).deep_symbolize_keys

          expected_error_type = 'Validation failed: Phone number must be ten characters long, Phone number must only contain numeric values'
          expect(parsed_response[:error]).to eq expected_error_type
        end

        it 'logs the correct api request error message' do
          post api_v1_user_exams_path(params: bad_phone_number_params)

          expected_error_type = 'ActiveRecord::RecordInvalid: Validation failed: Phone number must be ten characters long, Phone number must only contain numeric values'
          expect(ApiRequest.last.message).to eq expected_error_type
        end
      end

      context 'when the first_name param is missing' do
        let(:empty_first_name_params) { params.clone }

        before do
          empty_first_name_params.delete(:first_name)
        end

        it 'has a 400 status code' do
          post api_v1_user_exams_path(params: empty_first_name_params)
          expect(response.status).to eq 400
        end

        it 'returns the correct error object' do
          post api_v1_user_exams_path(params: empty_first_name_params)
          parsed_response = JSON.parse(response.body).deep_symbolize_keys

          expected_error_type = 'Invalid parameters'
          expect(parsed_response[:error]).to eq expected_error_type
        end

        it 'logs the correct api request error message' do
          post api_v1_user_exams_path(params: empty_first_name_params)

          expected_error_type = 'ActionController::BadRequest: Invalid parameters'
          expect(ApiRequest.last.message).to eq expected_error_type
        end
      end

      context 'when the last_name param is missing' do
        let(:empty_last_name_params) { params.clone }

        before do
          empty_last_name_params.delete(:last_name)
        end

        it 'has a 400 status code' do
          post api_v1_user_exams_path(params: empty_last_name_params)

          expect(response.status).to eq 400
        end

        it 'returns the correct error object' do
          post api_v1_user_exams_path(params: empty_last_name_params)

          parsed_response = JSON.parse(response.body).deep_symbolize_keys

          expected_error_type = 'Invalid parameters'
          expect(parsed_response[:error]).to eq expected_error_type
        end

        it 'logs the correct api request error message' do
          post api_v1_user_exams_path(params: empty_last_name_params)

          expected_error_type = 'ActionController::BadRequest: Invalid parameters'
          expect(ApiRequest.last.message).to eq expected_error_type
        end
      end

      context 'when an exam is not found' do
        let(:no_exam_params) { params.clone }

        before do
          no_exam_params[:exam_id] = 0
        end

        it 'has a 400 status code' do
          post api_v1_user_exams_path(params: no_exam_params)

          expect(response.status).to eq 400
        end

        it 'returns the correct error object' do
          post api_v1_user_exams_path(params: no_exam_params)

          parsed_response = JSON.parse(response.body).deep_symbolize_keys

          expected_error_type = 'Record Not Found'
          expect(parsed_response[:error]).to eq expected_error_type
        end

        it 'logs the correct api request error message' do
          post api_v1_user_exams_path(params: no_exam_params)

          expected_error_type = "ActiveRecord::RecordNotFound: Couldn't find Exam with 'id'=0 [WHERE \"exams\".\"college_id\" = $1]" 
          expect(ApiRequest.last.message).to eq expected_error_type
        end
      end

      context 'when an exam does not belong to the college' do
        let(:other_college) { College.create(name: 'other college') }
        let(:different_college_id_params) { params.clone }

        before do
          different_college_id_params[:college_id] = other_college.id
        end

        it 'has a 400 status code' do
          post api_v1_user_exams_path(params: different_college_id_params)

          expect(response.status).to eq 400
        end

        it 'returns the correct error object' do
          post api_v1_user_exams_path(params: different_college_id_params)

          parsed_response = JSON.parse(response.body).deep_symbolize_keys

          expected_error_type = 'Record Not Found'
          expect(parsed_response[:error]).to eq expected_error_type
        end

        it 'logs the correct api request error message' do
          post api_v1_user_exams_path(params: different_college_id_params)

          expected_error_type = "ActiveRecord::RecordNotFound: Couldn't find Exam with 'id'=#{exam.id} [WHERE \"exams\".\"college_id\" = $1]" 
          expect(ApiRequest.last.message).to eq expected_error_type
        end
      end

      context 'when a user fails to be found or created' do
        let(:bad_user_params) { params.clone }

        before do
          bad_user_params[:first_name] = ''
        end

        it 'has a 400 status code' do
          post api_v1_user_exams_path(params: bad_user_params)

          expect(response.status).to eq 400
        end

        it 'returns the correct error object' do
          post api_v1_user_exams_path(params: bad_user_params)

          parsed_response = JSON.parse(response.body).deep_symbolize_keys

          expected_error_type = 'Validation failed: First name can\'t be blank'
          expect(parsed_response[:error]).to eq expected_error_type
        end

        it 'logs the correct api request error message' do
          post api_v1_user_exams_path(params: bad_user_params)

          expected_error_type = 'ActiveRecord::RecordInvalid: Validation failed: First name can\'t be blank'
          expect(ApiRequest.last.message).to eq expected_error_type
        end
      end

      context 'when a requested start_time is before an exam\'s start window' do
        let(:later_exam_window) { ExamWindow.create(start_time: Time.now + 1.hour, end_time: Time.now + 2.hour) }
        let(:exam_with_later_time) { college.exams.create(exam_window_id: later_exam_window.id) }
        let(:exam_with_later_time_params) { params.clone }

        before do
          exam_with_later_time_params[:exam_id] = exam_with_later_time.id
        end

        it 'has a 400 status code' do
          post api_v1_user_exams_path(params: exam_with_later_time_params)

          expect(response.status).to eq 400
        end

        it 'returns the correct error object' do
          post api_v1_user_exams_path(params: exam_with_later_time_params)

          parsed_response = JSON.parse(response.body).deep_symbolize_keys

          expected_error_type = 'Start time is not within the exam window'
          expect(parsed_response[:error]).to eq expected_error_type
        end

        it 'logs the correct api request error message' do
          post api_v1_user_exams_path(params: exam_with_later_time_params)

          expected_error_type = 'ActionController::BadRequest: Start time is not within the exam window'
          expect(ApiRequest.last.message).to eq expected_error_type
        end
      end

      context 'when a requested start_time is after an exam\'s end window' do
        let(:earlier_exam_window) { ExamWindow.create(start_time: Time.now - 3.hour, end_time: Time.now - 1.hour) }
        let(:exam_with_earlier_time) { college.exams.create(exam_window_id: earlier_exam_window.id) }
        let(:exam_with_earlier_time_params) { params.clone }

        before do
          exam_with_earlier_time_params[:exam_id] = exam_with_earlier_time.id
        end

        it 'has a 400 status code' do
          post api_v1_user_exams_path(params: exam_with_earlier_time_params)

          expect(response.status).to eq 400
        end

        it 'returns the correct error object' do
          post api_v1_user_exams_path(params: exam_with_earlier_time_params)

          parsed_response = JSON.parse(response.body).deep_symbolize_keys

          expected_error_type = 'Start time is not within the exam window'
          expect(parsed_response[:error]).to eq expected_error_type
        end

        it 'logs the correct api request error message' do
          post api_v1_user_exams_path(params: exam_with_earlier_time_params)

          expected_error_type = 'ActionController::BadRequest: Start time is not within the exam window'
          expect(ApiRequest.last.message).to eq expected_error_type
        end
      end

      context 'when a user is already assigned to an exam' do
        let(:user) { User.create(first_name: 'bob', last_name: 'jones', phone_number: '0123456789') }

        before do
          exam.users << user
        end

        it 'has a 400 status code' do
          post api_v1_user_exams_path(params: params)

          expect(response.status).to eq 400
        end

        it 'returns the correct error object' do
          post api_v1_user_exams_path(params: params)

          parsed_response = JSON.parse(response.body).deep_symbolize_keys

          expected_error_type = 'Validation failed: User has already been taken'
          expect(parsed_response[:error]).to eq expected_error_type
        end

        it 'logs the correct api request error message' do
          post api_v1_user_exams_path(params: params)

          expected_error_type = 'ActiveRecord::RecordInvalid: Validation failed: User has already been taken'
          expect(ApiRequest.last.message).to eq expected_error_type
        end
      end
    end
  end
end