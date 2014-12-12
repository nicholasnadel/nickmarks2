Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root to: 'welcome#index', as: :user_root
  post :incoming, to: 'incoming#create'

  resources :users, except: [:index]
  resources :bookmarks
  resources :bookmarks
  resources :welcome

  post '/up-vote' => 'votes#up_vote', as: :up_vote
  post '/down-vote' => 'votes#down_vote', as: :down_vote


  unauthenticated do
    root to: 'home#show', as: :unauthed_root
  end
end


