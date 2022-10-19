
Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  
  
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'  
  
  resources   :events
  resources   :users 
  resource    :event do
    resource :avatar
  end
  resource    :user do
    resource :avatar
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  root        "events#index"  
  
  match  'login'   => 'users#login',  :as  => :login,  :via => [:post, :get] 
  match  'logout'  => 'users#logout', :as  => :logout, :via => [:post, :get]
  get    'signup'  => 'users#new',    :as  => :signup

  get 'sessions/new' 	 => 'sessions#new'
  post  'new'     	 => 'events#new' 
  post 'events/:id'  	 =>  'events#update' 
  post 'users/:id'   	 =>  'users#update'  
  match 'users/:id/edit' => 'users#edit', :as => :edit, :via => [:get]
  match '/uploads/event/avatar/:id/*other.:format' => 'events#show', :as=>"uploads", :via => [:get]
  #get    'login'   => 'sessions#new' 
  #post   'login'   => 'sessions#create' 
  #delete 'logout' => 'sessions#destroy' 
  #post 'events/:id/picture_store' => 'events#picture_store'
  #post 'events/:id/edit' => 'events#edit'
  #post 'events/picture_store' => 'events#picture_store'
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
 
  #match ':controller(/:action(/:id(.:format)))'

end
