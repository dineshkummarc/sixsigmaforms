ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  map.register_admin '/admins/register', :controller => 'admins', :action => 'register'
  map.register_user '/users/register', :controller => 'users', :action => 'register'
  map.resources :admins, :sessions
  map.resources :doctors, :users
#  map.resources :doctors do |doctor|
#    doctor.resources :users
#  end
  map.doctor_login '/:doctor_alias/login', :controller => 'sessions', :action => 'create'
  map.doctor_user '/:doctor_alias/users/:action/:id', :controller => 'users'
  map.connect '/login', :controller => 'sessions', :action => 'create', :doctor_alias => 'SSAdmin'
  map.connect '/logout', :controller => 'sessions', :action => 'destroy'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
