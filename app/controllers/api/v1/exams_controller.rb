module Api
  module V1
    class ExamsController < ApplicationController
      def show
        begin
          user = User.find_or_create_user(user_params)
          exam = Exam.find(params[:id])
          render json: exam
        rescue ActiveRecord::RecordInvalid => e
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

# {  

#     first_name: String, 
  
#     last_name: String, 
  
#     phone_number: String, 
  
#     college_id: Integer, 
  
#     exam_id: Integer, 
  
#     start_time: DateTime 
  
#   }  