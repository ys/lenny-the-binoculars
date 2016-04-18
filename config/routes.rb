Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  #
  resources :webhooks, only: :create
  resources :pull_requests, only: %w{index show}
  get "/auth/github/callback", to: "sessions#github"
  root to: "root#index"
end
