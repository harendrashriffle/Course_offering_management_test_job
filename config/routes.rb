Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post "user_login", to: "users#user_login"
  resources :users
  resources :courses do
    collection do
      post "enroll_course", to: "courses#enroll_course"
      get "show_enrolled_course", to: "courses#show_enrolled_course"
      post "assign_course_instructor", to: "courses#assign_course_instructor"
    end
  end
end
