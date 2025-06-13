# frozen_string_literal: true

Rails.application.routes.draw do
  mount Flipflop::Engine => '/flipflop'
  mount HealthMonitor::Engine, at: '/'
  resources :locker_renewal_messages
  resources :study_room_violations
  resources :locker_violations
  resources :study_room_assignments
  resources :study_rooms do
    get 'assign_users', on: :collection
    put 'update_assignments', on: :collection
  end
  root 'locker_applications#new'

  resources :locker_applications do
    get 'awaiting_assignment', on: :collection
    member do
      get 'assign'
      put 'toggle_archived'
    end
  end
  resources :locker_assignments, except: :new do
    get 'assignment_report', on: :collection, defaults: { format: :csv }
    get 'occupancy_report', on: :collection, defaults: { format: :csv }
    member do
      get 'card'
      get 'release'
    end
  end
  resources :lockers do
    member do
      get 'disable'
      get 'enable'
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
