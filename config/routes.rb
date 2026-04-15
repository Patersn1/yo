# frozen_string_literal: true

Rails.application.routes.draw do

  resources :rides

  get 'message/index'

  get 'approval/', to: 'approval#index'
  get 'pending/', to: 'pending#index'
  resources :notifications
  get 'photos/index'
  get 'photos/new'
  get 'photos/create'
  get 'photos/destroy'

  # search page
  get '/search', to: "search#index"
  resources :organizataions

  # message page
  get '/message', to: "message#index"

  # resources :opportunities_tags
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :issue_areas
  # link-up auth libraries
  devise_for :users, sign_out_via: [:delete, :get]

  scope format: false do
    resources :organizations, constraints: { id: /.+/ }
  end
  
  get '/organizations/new'
  get '/opportunities/new'

  get '/opportunities/roster/:id', to: 'opportunities#roster', as: 'roster'
  # Add route to approve rides page
  get '/rides/approve_rides/:id', to: 'rides#approve_rides', as: 'approveride'
  
  resources :opportunities
  
  # added resources so updates can be made to either request a ride or for a driver to remove a rider if they do not approve to drive them
  resources :rides,   only: [:create, :destroy] do
    collection do
      put :update
    end
  end

  resources :favorite_opportunities
  resources :favorite_organizations

  resources :photos, only: %i[index new create destroy]

  # added ideas as a resource with all CRUD opertions
  # also added methods approve to allow admin users to approve/unapprove ideas
  resources :opportunities do
    put :favorite, on: :member
  end

  # routes the root directory to the homepage
  root 'welcome#welcome'
  get '/dashboard', to: 'organizations#dashboard', as: :dashboard_path
  get '/add_tags', to: 'users#show'
  put '/add_tags/add', to: 'users#add_tags', constraints: { sender: /[^\/]+/ }

  #routes for approval process
  get '/approval/approve_opp/:opp_id', to: 'approval#approve_opp'
  get '/approval/approve_org/:org_id', to: 'approval#approve_org'
  get '/approval/dismiss_opp/:opp_id', to: 'approval#dismiss_opp'
  get '/approval/dismiss_org/:org_id', to: 'approval#dismiss_org'

  # Add route to profile page
  get '/users/profile_page', to: 'users#profile_page', as: :profile_page
  get '/users/new_org', to: 'users#new_org', as: :new_org

  # Add route to student editing song
  get '/users/edit', to: 'users#edit', as: :edit_student

  # Volunteer form system
  post '/opportunities/:id/toggle_volunteer_status', to: 'opportunities#toggle_volunteer_status', as: 'toggle_volunteer_status'
  get '/opportunities/:id/volunteers', to: 'opportunities#volunteers', as: 'opportunity_volunteers'

  devise_for :users, controllers: {registrations: 'user/registrations'}

  # Organization routes
  resources :organizations, only: [:edit, :update, :show]

  # Admin only routes
  namespace :admin do
    resources :users, only: [:index, edit, :update]
  end
end
