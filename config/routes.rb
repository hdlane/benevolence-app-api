# == Route Map
#

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :coordinators
      resources :delivery_dates
      resources :organizations
      resources :people
      resources :providers
      resources :requests
      resources :resources

      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"
      get "/login/verify", to: "sessions#verify"
      get "/oauth", to: "integrations#oauth"
      get "/oauth/complete", to: "integrations#oauth_complete"
      get "/sync", to: "integrations#sync"
    end
  end
end
