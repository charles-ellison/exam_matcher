module Api
  module V1
    class ExamsController < ApplicationController
      def show
        user = User.find_or_create_user(user_params)

        render json: user
      end

      private 

      def user_params
        params.permit(:first_name, :last_name, :college_id, :phone_number)
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