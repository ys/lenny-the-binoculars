Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  #
  resources :webhooks, only: :create
  resources :pull_requests, only: %w{index show}
  resources :repos, only: %w{create destroy}
  resources :tokens, only: %w{index create}
  get "/:owner/:name", to: "repos#show"
  delete "/:owner/:name", to: "repos#destroy"
  get "/api/:owner/:name", to: "api/repos#show"
  get "/api", to: "api/base#root"
  get "/auth/github/callback", to: "sessions#github"
  if ENV['ACME_KEY'] && ENV['ACME_TOKEN']
    get ".well-known/acme-challenge/#{ ENV["ACME_TOKEN"] }" => proc { [200, {}, [ ENV["ACME_KEY"] ] ] }
  else
    ENV.each do |var, _|
      next unless var.start_with?("ACME_TOKEN_")
      number = var.sub(/ACME_TOKEN_/, '')
      get ".well-known/acme-challenge/#{ ENV["ACME_TOKEN_#{number}"] }" => proc { [200, {}, [ ENV["ACME_KEY_#{number}"] ] ] }
    end
  end
  root to: "root#index"
end
