# http://guides.rubyonrails.org/action_controller_overview.html

require_dependency "praetorian/application_controller"

module Praetorian
  class SessionsController < ApplicationController

# Displays a new sign in session template for a user to fill in the user email and password for user authentication.
    def new

      cookies[:name] = "anthony"
      cookies.delete(:name)

    ##DEBUGGING TO RAILS WEB SERVER LOG FILE  
      # Expected result = true
      puts "Is cookies hash name in SESSIONS CONTROLLER NEW ACTION nil? #{cookies[:name].nil?}"
      # Expected result = false
      puts "Is cookies hash name in SESSIONS CONTROLLER NEW ACTION present? #{cookies[:name].present?}"

    # In ruby, the fail method is synonymous to raise which raises a runtime error to stop the code execution and inspect values. The fail keyword is a method of the Kernel module which is included by the class Object.
    #  fail cookies[:name]
    end

    # Performs two level user authentication after sign in session template is filled in with the email, password & submitted!  
    def create
    # params is hash available only at the controller level.  We can assign params values at the controller level and pass as arguments to other classes such as the User model.
      if user = User.authenticate(params[:email], params[:password])
        if params[:remember_me]
    # Assign the id of the user object to session hash user_id.  Only store the user_id to keep session small.  The user_id is all that is needed when a request comes in to then go look up the user object again.
    #session[:user_id] = user.id 'prior to implementing remember me & reset password
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
    ##DEBUGGING TO RAILS WEB SERVER LOG FILE
        puts "Cookies Hash Auth Token in SESSIONS CONTROLLER CREATE ACTION: #{cookies[:auth_token]}!!!"
        puts "Params Hash Controller Name in SESSIONS CONTROLLER CREATE ACTION: #{params[:controller]}"
        puts "Params Hash Action Name in SESSIONS CONTROLLER CREATE ACTION: #{params[:action]}"
        puts "ApplicationController PARAMS METHOD CONTROLLER_NAME in SESSIONS CONTROLLER CREATE ACTION: #{controller_name}"
        puts "ApplicationController PARAMS METHOD ACTION_NAME in SESSIONS CONTROLLER CREATE ACTION: #{action_name}"    
    
        redirect_to root_url, notice: "Welcome back, #{user.email}!"
      else
    # We are not issuing a new request here.  Render new is just going to render the template in the same request that ran this create action.  That's why flash.now is required.  Otherwise, we would have to wait for another request to get this invalid email or password combination.
        flash.now.alert = "Invalid email or password!"
        render "new"
      end
    end

    def destroy
    # Note that while for session values you set the key to nil, to delete a cookie value you should use cookies.delete(:key).  

    # In ruby, fail is synonymous to raise. The fail keyword is a method of the Kernel module which is included by the class Object. The fail method raises a runtime error just like the raise keyword.  It is similar to a breakpoint to stop the code execution and inspect values.

      #session[:user_id] = nil
      #reset session
  
      cookies.delete(:auth_token)

      puts "Is cookies hash auth_token in SESSIONS CONTROLLER DESTROY ACTION nil? #{cookies[:auth_token].nil?}"
      #present checks for nil or an empty string.
      puts "Is cookies hash auth_token in SESSIONS CONTROLLER DESTROY ACTION present? #{cookies[:auth_token].present?}"
      # fail cookies[:auth_token]
      # result is nil? true and present? false - this working correctly at this point.

    # When logging out, at the completion of the destroy action, nil? is true and present? is false as expected.  When redirecting to root_url, there is no cookies[:auth_token] value, however nil? is changed from true just prior to the redirect to false just after the redirect.  It does travel through the application controller and before_action :authorize.  This is were it is happening.
      cookies[:auth_token] = nil
      redirect_to root_url, notice: "Signed Out!"
    end
  end
end
