# == Route Map
#

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # resources :coordinators
      # resources :delivery_dates
      # resources :organizations
      resources :people, only: :index
      resources :providers, only: :destroy
      resources :requests
      resources :resources, only: [ :create, :update, :destroy ]

      post "/login", to: "sessions#login_link"
      delete "/logout", to: "sessions#destroy"
      get "/me", to: "sessions#me"
      get "/login/verify", to: "verifications#verify_login_link"
      post "/login/verify/organization", to: "verifications#verify_organization"
      post "/login/verify/person", to: "verifications#verify_person"
      get "/oauth", to: "integrations#oauth"
      get "/oauth/complete", to: "integrations#oauth_complete"
      get "/sync", to: "integrations#sync"
      get "/admin/overview", to: "administrator#overview"
    end
  end
end
