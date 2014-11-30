Rails.application.routes.draw do
  devise_for :users, skip: [:passwords, :registrations], controllers: { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    root :to => 'devise/sessions#new'
  end

  resources :interviews, only: [:index, :new, :create]
end
