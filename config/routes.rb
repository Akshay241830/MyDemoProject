Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'homes#index'

  devise_scope :user do
    get 'users/sign_out' => 'devise/sessions#destroy'
  end

  resources :hotels do
    collection do
      get 'search'
    end

    # resources :rooms, shallow: true do
    resources :bookings, shallow: true do
      collection do
        get 'availability', to: 'bookings#availability' # For the input form
        get 'check_availability', to: 'bookings#check_availability' # For processing the input
      end
    end

    # end
  end

  get '/index', to: 'bookings#index'  
  # resources 

  resources :bookings, only: [:index]


  # config/routes.rb
  resources :payments, only: [] do
    collection do
      get :create_session
      get :success
      get :cancel
      get '/success/:id', to: 'payments#success'
    end  

    member do
      post :refund 
    end
    # member do
    #   post :refund
    # end
  end 

  # config/routes.rb
# resources :payments, only: [] do
#   member do
#     post :refund # This should be POST, not GET
#   end
# end


  resources :users do
    resources :bookings, only: [:index]
  end


  # resources :hotels do
  #   collection do
  #     get 'search'
  #   end

  #   # resources :rooms, shallow: true do
  #   resources :bookings
  #   # end
  # end

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

  # post 'bookings/availability', as: :availability_bookings

  # resources :hotels do
  #   collection do
  #     get 'search'
  #   end
  #   resources :rooms, shallow: true do
  #     # get 'availability', on: :collection, to: 'bookings#availability', as: 'rooms_availability'
  #     resources :bookings do
  #       get 'availability', to: 'bookings#availability'
  #     end
  #   end
  #   resources :bookings, only: %i[index new create]
  # end

  # resources :bookings

  # # resources :bookings do
  # #   member do
  # #     get :edit
  # #     patch :update
  # #   end
  # # end
end
