module Api
  module V1
    class ExamsController < ApplicationController
      RESCUEABLE_ERRORS = [ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ActionController::BadRequest]

      def show
        begin
          user = User.find_or_create_user(user_params)
          college = College.find(params[:college_id])
          exam = college.exams.find(params[:id])

          start_time = params[:start_time].to_datetime
          raise ActionController::BadRequest unless exam.start_window <= start_time && exam.end_window >= start_time

          render json: exam
        rescue *RESCUEABLE_ERRORS => e
          render json: { error: 'Invalid exam parameters' }, status: 400
        end
      end

      private 

      def user_params
        params.permit(:first_name, :last_name, :phone_number)
      end
    end
  end
end