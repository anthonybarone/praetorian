require_dependency "praetorian/application_controller"

# modules are good for creating buckets of related methods, mixins (a module that has methods that get mixed into other classes to follow DRY principle) and namespaces.

module Praetorian
  class UsersController < ApplicationController
    
    def index
      @users = Praetorian::User.all
    end
    
    def show
      @user = Praetorian::User.find(params[:id])
  #   @user = User.find(cookies[:auth_token])
    end    
    
    def new
      @user = Praetorian::User.new
    end

    def create
      @user = Praetorian::User.new(user_params)
      if @user.save
  #     session[:user_id] = @user.id
        cookies[:auth_token] = @user.auth_token
        redirect_to root_url, notice: "Thank you for signing up!"
      else
        render "new"
      end
    end

    def edit
      @user = Praetorian::User.find(params[:id])
    end

    def update
      @user = Praetorian::User.find(params[:id])
      if @user.update(user_params)
        redirect_to @user, notice: "Account successfully updated!"
      else
        render :edit
      end
    end

    def destroy
      @user = Praetorian::User.find(params[:id])
      @user.destroy
      session[:user_id] = nil
      redirect_to root_url, alert: "Account successfully deleted!"
      cookies[:auth_token] = nil
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
    
  end
end
