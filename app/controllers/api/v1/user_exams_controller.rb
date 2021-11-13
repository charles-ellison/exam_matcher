module Api
  module V1
    class UserExamsController < ApplicationController
      RESCUEABLE_ERRORS = [ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ActionController::BadRequest]

      def create
        begin
          validate_params
          exam = Exam.assign_exam_to_user(user_params, exam_params)
          ApiRequest.log_success(exam.id)

          render json: exam
        rescue *RESCUEABLE_ERRORS => error
          ApiRequest.log_failure(error)

          error_message = error.class == ActiveRecord::RecordNotFound ? 'Record Not Found' : error.message
          render json: { error: error_message }, status: 400
        end
      end

      private

      def user_params
        params.permit(:first_name, :last_name, :phone_number)
      end

      def exam_params
        params.permit(:college_id, :exam_id, :start_time)
      end

      def validate_params
        valid_params = [:first_name, :last_name, :phone_number, :college_id, :exam_id, :start_time].all? { |key| params.has_key?(key) }
        raise ActionController::BadRequest.new('Invalid parameters') unless valid_params
      end
    end
  end
end