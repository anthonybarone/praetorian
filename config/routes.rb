Praetorian::Engine.routes.draw do

  get 'signup', to: 'users#new', as: 'signup'
  get 'signin', to: 'sessions#new', as: 'signin'

  # This action uses POST parameters. They are most likely coming
  # from an HTML form which the user has submitted. The URL for
  # this RESTful request will be "/clients", and the data will be
  # sent as part of the request body.

  delete 'signout', to: 'sessions#destroy', as: 'signout'

  # The users#index action uses query string parameters because they get run by HTTP GET requests, but this does not make any difference to the way in which the parameters are accessed. The URL for this action would look like this in order to list activated clients: /users?status=activated

  # This users#create action uses POST parameters. They are most likely coming from an HTML form which the user has submitted. The URL for this RESTful request will be "/users", and the data will be sent as part of the request body.
  
  resources :users
  # rails convention for a singular resource to accurately map the way a session resource is used in term of URLS (no :id in path and no show index necessary).  This works in pragmatic programmers implementation of sign in but not in railscasts implementation of sign in.
  resource :session
  resources :password_resets

  
  root :to => 'users#index'
  
end
