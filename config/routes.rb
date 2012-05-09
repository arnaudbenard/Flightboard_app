Mvp::Application.routes.draw do

  resources :keywords do 
    	member do
        get :vote_up
        get :vote_down
      end
  end
 
  get "pages/about"
  get "pages/test"
  get "pages/test2"
  get "jobs/autopilot"
  match "/about" => "pages#about"
  match "/apply" => "jobs#index"


  resources :jobs do

  	member do 
  		get 'mcdm'
      get 'autopilot'
  		match 'apply' => "candidates#new"
      match 'autopilot' => "jobs#autopilot"
  	end

  	resources :candidates do
        resources :comments 
  		member do

        get :vote_up
        get :vote_down
      end
    end

    resources :criteria do 
  		member do
        get :vote_up
        get :vote_down
      end
    end
  end

  authenticated :user do
    root :to => 'jobs#index'
  end
  root :to => "users#show"
  devise_for :users
  resources :users, :only => :show

  
end
