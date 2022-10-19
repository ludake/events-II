class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:notice] = t"Account activated!"
      session[:user_id] = user.id
      redirect_to user
    else
      flash[:notice]  = t"Invalid activation link"
      redirect_to root_url
    end
  end
end
