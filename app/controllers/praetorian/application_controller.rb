module Praetorian
  class ApplicationController < ActionController::Base
    
    # Prevent CSRF attacks by raising an exception.  For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
 
    # Callbacks are just hooks into an ActiveRecord object’s life cycle. Actions can be performed “before”, “after”, or even “around” ActiveRecord events, such as save, validate, or create. Also, callbacks are cumulative, so you can have two actions which occur before_update, and those callbacks will be executed in the order they occur.  If you’re not testing your ActiveRecord models, you’ll begin noticing pain later as your application grows and as more logic is required to call or avoid the callback.
    # “before_” callbacks are generally used to prepare an object to be saved. Updating timestamps or incrementing counters on the object are the sort of things we do “before” the object is saved. On the other hand, “after_*” callbacks are primarily used in relation to saving or persisting the object. Once the object is saved, the purpose (i.e. responsibility) of the object has been fulfilled, and so what we usually see are callbacks reaching outside of its area of responsibility, and that’s when we run into problems.  
    # Follow one simple rule to avoid callback hell:  Use a callback only when the logic refers to state internal to the object.  If we can’t use callbacks which extend responsibility outside their class, what do we do? We make an object whose responsibility is to handle that callback.

    # The before_action :authorize callback method prepares what controller actions and parameters a user is permitted to perform before each request for a given resource.


###    before_action :authorize
  
    # DELEGATE + HELPER_METHOD NOTES:
    # delegate :permit_action?, :permit_param? to: :current_permssion exposes these methods in the permission class to the ApplicationController current_permission method that can be used as if it were its own.  This is demonstrated in the ApplicationController authorize method.  The delegate macro receives one or more method names (specified as symbols or strings) and the name of the target object via the :to option (also a symbol or string).  The current_permission method is what instantiates a new permission object for a given current_user.
    # declaring helper_methods :permit_action?, :permit_param? and :current_user? it makes them available for conditional logic in the views.  These are simply the name of methods in the Application Controller and Permission Model made available in the view.  The combination of of the helper_methods available in the view and delegation of the permission methods to current_permission exposes the permission class methods to the ApplicationController current_permission method.  The current_user method does not need to be delegated because it is in the ApplicationController class, not the Permission class.  Powerful stuff!

    delegate :permit_action?, to: :current_permission
    helper_method :permit_action?

    delegate :permit_param?, to: :current_permission
    helper_method :permit_param?

    # Set up as private methods because we are not going to call any of these as actions
    private

    # Given the delegate declaration, the authorize method calls the current_permission permit_action? passing the controller, action and current resource arguments.  It also delegates the current_permission permit_params! params as a dynamic implementation of strong parameters.  The way this works is is accepts a params hash from the controller.  First we check if we allow all.  If so, we permit with a bang on the params hash which is a method strong parameters provides to allow everything.  Otherwise, we are going to loop through all of the permitted parameters we defined in the intialize method and basically call permit on each of those permitted resources and passing in each of the defined attributes we have defined as permitted.
    def authorize
    # Application Helper Method that ensures cookies[:auth_token] is assigned nil if not present to ensure "if cookies[:auth_token]" is correctly evaluated.
      cookies_auth_token_not_present

      puts "Cookies Hash Auth Token in BEFORE_ACTION AUTHORIZE METHOD:!!!#{cookies[:auth_token]}!!!"
      puts "Is cookies hash auth token in BEFORE_ACTION AUTHORIZE METHOD nil?#{cookies[:auth_token].nil?}"
      puts "Is cookies hash auth token in BEFORE_ACTION AUTHORIZE METHOD present?#{cookies[:auth_token].present?}"

      if  current_permission.permit_action?(params[:controller], params[:action], current_resource)
          current_permission.permit_params! params
      else
        redirect_to root_url, alert: "Not authorized."
      end
    end

    # If a user is signed in, cookies[:auth_token] is assigned user.auth_token through the sessions controller create action.
    # Current_user determines if signed in by simply fetching the currently logged in user object using the cookies[:auth_token] assigned at sign in if cookies[:auth_token].
    # Current_user either returns the entire user object to be used if fetched or false if not fetched.
    # Since this may be called many times per request, it is cached in an instance variable called @current_user so it is only called one time per request.
    # Refactored to use the auth_token instead of the user_id to fetch our user.The current_user method finds if the current user exists by searching if the user model auth_token exists.  The cookies auth_token was implmented as part of the user authentication feature.  The current_user helper method is used when instantiating a new permission object.

    def current_user
    #DEBUGGING TO RAILS WEB SERVER LOG FILE
      puts "Cookies Hash Auth Token in CURRENT_USER METHOD:!!!#{cookies[:auth_token]}!!!"
      puts "Is cookies hash auth token in CURRENT_USER METHOD nil?#{cookies[:auth_token].nil?}"
      puts "Is cookies hash auth token in CURRENT_USER METHOD present?#{cookies[:auth_token].present?}"
      puts "Params Hash Controller Name in CURRENT_USER METHOD:#{params[:controller]}"
      puts "Params Hash Action Name in CURRENT_USER METHOD:#{params[:action]}"

    # Application Helper Method that ensures cookies[:auth_token] is assigned nil if not present to ensure "if cookies[:auth_token]" is correctly evaluated.
      cookies_auth_token_not_present

    # In Ruby, everything is an expression, and an expression will return the last value evaluated within it. || returns the result of the last expression evaluated. If it evaluates the left hand side (LHS) and finds a true value, you get the LHS; otherwise, you get the RHS (no matter what that RHS might be).
    # The common but initially obscure ||= (“or equals”) assignment operator is used to assign @current_user. Its effect is to set the @current_user instance variable to the user corresponding to the remember token (in our case auth token), but only if @current_user is undefined. In other words, the construction calls the find_by method the first time current_user is called, but on subsequent invocations returns @current_user without hitting the database. This is only useful if current_user is used more than once for a single user request; in any case, find_by will be called at least once every time a user visits a page on the site.
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
      @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    end

      helper_method :current_user


    def cookies_auth_token_not_present
      if !cookies[:auth_token].present?
        cookies[:auth_token] = nil
        puts "cookies[:auth_token] WAS NOT PRESENT IN AUTHORIZE METHOD!!!"
      end
    end

    # VERY SIMPLY, current_resource is initially set to nil in the application_controller and then @current_resource is set to the controller at hand params id using the find method.
    def current_resource
      nil
      #@current_resource ||= current_user
    end

    # Call the Permission class to instantiate a new Permission object and pass in the current_user since it will need that information.  Also handle this with some caching by storing in a @current_permission instance variable so that it is only instantiated once if called several times.
    def current_permission
      @current_permission ||= Permission.new(current_user)
    end

    # Moved current_user method into application_helper.rb
    #helper_method :current_user

    if __FILE__ == $0
      puts "Controller Name: #{params[:controller]}"
      puts "Action Name: #{params[:action]}"
      puts "Current User: #{@current_user}"
    end 
        
  end
end
