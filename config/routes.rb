Rails.application.routes.draw do
  namespace :api do
    namespace :v1, format: :json do
      resources :user_exams, only: [:create]
    end
  end
end
