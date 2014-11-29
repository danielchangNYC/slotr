Rails.application.routes.draw do

  devise_for :users, skip: [:passwords, :registrations], controllers: { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    # get 'users/sign_up(/:invitation_token)' => "users/registrations#new", as: 'new_user_registration'
    root to: "devise/sessions#new"
  end
end
