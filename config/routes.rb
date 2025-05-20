Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # Stores routes
  resources :stores do
    # Nested items routes under a store (contextual creation & listing)
    resources :items, only: [ :index, :create ] do
      collection do
        get :count
      end
    end
  end

  # Items routes (flat for show/edit/update/delete)
  resources :items, only: [ :show, :update, :destroy ] do
    # Nested ingredients routes under an item (contextual creation & listing)
    resources :ingredients, only: [ :index, :create ]
  end

  # Ingredients routes (flat for show/edit/update/delete)
  resources :ingredients, only: [ :show, :update, :destroy ]
end
