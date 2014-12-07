Rails.application.routes.draw do
  devise_for :users, skip: [:passwords, :registrations], controllers: { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    root :to => 'devise/sessions#new'
  end

  resources :interviews, only: [:index, :new, :create, :edit, :update] do
    get '/new_schedule_responses' => 'interviews#new_schedule_responses', as: :new_schedule_responses
    post '/create_schedule_responses' => 'interviews#create_schedule_responses', as: :create_schedule_responses
  end

  resources :possible_interview_blocks, only: [:destroy]

  get '/schedule_responses/:code' => 'schedule_responses#show', as: :schedule_response
end
