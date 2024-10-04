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

      post "/login", to: "sessions#login_link"
      post "/login/create", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
      get "/login/verify", to: "verifications#verify_login_link"
      post "/login/verify/organization", to: "verifications#verify_organization"
      post "/login/verify/person", to: "verifications#verify_person"
      get "/oauth", to: "integrations#oauth"
      get "/oauth/complete", to: "integrations#oauth_complete"
      get "/sync", to: "integrations#sync"
    end
  end
end
