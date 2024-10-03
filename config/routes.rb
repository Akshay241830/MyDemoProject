Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "homes#index"

  devise_scope :user do
    get 'users/sign_out' => "devise/sessions#destroy"
  end 

  resources :hotels do  
    
    collection do 
      get 'search'
    end
    resources :rooms, shallow: true do
      resources :bookings, shallow: true
    end
    resources :bookings, only: [:index, :new, :create]
  end
   resources :bookings

  resources :bookings do
    member do
      get :edit
      patch :update
    end
  end
end
