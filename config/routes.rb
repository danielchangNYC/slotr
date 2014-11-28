Rails.application.routes.draw do
  root to: 'static#index'

  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  # devise_scope :user do
  #   get 'users/sign_up(/:invitation_token)' => "users/registrations#new", as: 'new_user_registration'
  #   get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
  #   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end

  # devise_for :users, :path_names => { sign_in: 'login', sign_out: 'logout' },
  #   :controllers => {
  #    :omniauth_callbacks => "users/omniauth_callbacks",
  #    :sessions => "sessions"
  #   }
end
