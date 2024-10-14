Rails.application.routes.draw do
  get 'payments/new'
  get 'payments/create'
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
    
    # resources :rooms, shallow: true do
    resources :bookings do 
       collection do
         get 'availability', to: 'bookings#availability' # For the input form
         get 'check_availability', to: 'bookings#check_availability' # For processing the input
       end 
    end
      

    # end
  end  
  # resources :bookings 
  # resources :bookings, only: %i[index new create] do
  #   collection do
  #     get 'availability', to: 'bookings#availability' # For the input form
  #     get 'check_availability', to: 'bookings#check_availability' # For processing the input
  #   end
  # end





  # resources :hotels do  
    
  #   collection do 
  #     get 'search'
  #   end
  #   resources :rooms, shallow: true do
  #     resources :bookings, shallow: true
  #   end
  #   # resources :bookings, only: [:index, :new, :create]
  # end 

  # resources :bookings do  
  #   collection do
  #     post 'availability', to: 'bookings#availability'  # For the input form
  #     post 'availability', to: 'bookings#check_availability'  # For processing the input
  #   end
  # end
  



  # resources :payments, only: [:new, :create]
  # root 'payments#new'

  # resources :bookings do
  #   member do
  #     get :edit
  #     patch :update
  #   end
  # end
end
