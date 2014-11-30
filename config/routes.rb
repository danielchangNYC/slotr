Rails.application.routes.draw do
  devise_for :users, skip: [:passwords, :registrations], controllers: { :omniauth_callbacks => "users/omniauth_callbacks" }

  # devise_scope :user do
    root to: 'interviews#index'
  # end

  resources :interviews, only: [:index]
end
