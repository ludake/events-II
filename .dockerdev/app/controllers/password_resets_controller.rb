class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def edit
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:notice] = t'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:notice] = t'Email address not found'
      render 'new'
    end
  end
  
  def update
    if params[:user][:password].empty?                
      @user.errors.add(:password, I18n.t('can not be empty'))
      render 'edit'
    elsif @user.update(user_params)          
      @user.login
      flash[:notice] = t'Password has been reset.'
      redirect_to @user
    else
      render 'edit'                                     
    end
  end

  private
    
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # 检查重设令牌是否过期
    def check_expiration
      if @user.password_reset_expired?
        flash[:notice] = t'Password reset has expired.'
        redirect_to new_password_reset_url
      end
    end   

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 确保是有效用户
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
  
end
