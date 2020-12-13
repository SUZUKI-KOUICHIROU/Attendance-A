Rails.application.routes.draw do
  get 'bases/index'

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'working_employee'
      get 'attendances/edit_attendance_application'
      patch 'attendances/update_attendance_application'
      get 'attendances/attendance_log'
      post 'approvals/create'
      get 'approvals/edit_month_approval'
      patch 'approvals/update_month_approval'
    end
  resources :attendances, only: :update
  resources :approvals
  end
  resources :bases do
  end
end