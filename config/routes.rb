Rails.application.routes.draw do

  resources :users do
    collection { post :import }
  end
  
  get 'bases/index'

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      patch 'update_userinformation'
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'confirmation_show'
      #勤怠変更
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/edit_worktime_approval'
      patch 'attendances/update_worktime_approval'
      get 'working_employee'
      #所属長承認
      patch 'update_month_apply'
      get 'attendances/edit_month_approval'
      patch 'attendances/update_month_approval'
      #残業申請
      get 'attendances/edit_overwork_request'
      patch 'attendances/update_overwork_request'
      get 'attendances/edit_overwork_approval'
      patch 'attendances/update_overwork_approval'
  end
  resources :attendances, only: :update
  end
  resources :bases do
  end
  resources :attendancelogs do
  end
end
