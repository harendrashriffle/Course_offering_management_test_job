Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post "user_login", to: "users#user_login"
  resources :users
  resources :courses do
    post "enroll_course", to: "courses#enroll_course", on: :collection
    get "show_enrolled_course", to: "courses#show_enrolled_course", on: :collection
    post "assign_course_instructor", to: "courses#assign_course_instructor", on: :collection
  end
end
