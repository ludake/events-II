class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:create, :update] 
  #before_action :authenticate, :only => [:edit, :update]
  respond_to  :html, :xml, :json 
  
  #Carrierwave for upload picture
  #def save_picture
  #  params.permit!
  #  user_with_picture = User.new
  #  user_with_picture.picture= params[:user][:picture]
  #end

  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end
  
  def new
    @user = User.new
    respond_with(@user)
  end
  
  def create
    params.permit!
    @user = User.new(params[:user])

    
    respond_to do |format|
      if request.post? and @user.save
        @user.send_activation_email      
        flash[:notice] = I18n.t("Please check your email to activate your account.")
        #flash.now[:notice] = I18n.t('Dear') + @user.login + ',' + I18n.t('Thanks for signing up!')
        #session[:user_id] = @user.id
        format.html { redirect_to events_url }
        format.xml  { render :xml => events_url, :status => :created, :location => events_url }
        
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        
      end
    end
  end
    
  
  def edit
    
    current_user = User.find_by(id: params[:id])
    if current_user.activated?
      @user = current_user
      session[:user_id] = @user.id
    else
      message  = t("Account not activated.")
      message += t("Check your email for the activation link.")
      flash[:notice] = message
      redirect_to root_url
    end
  end
  
  def update
    @user = current_user
    
    respond_to do |format|
      if request.post?
        if current_user.activated?
	  if current_user.update(params.require(:user).permit(:password, :password_confirmation, :avatar))
	    flash[:notice] = t('Information updated')
	    format.html { redirect_to :action => 'show', :id => current_user.id }
	    format.xml  { head :ok }
	  else
	    format.html { render :action => "edit" }
	    format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
	        
	  end
        else 
          message  = t("Account not activated.")
          message += t("Check your email for the activation link.")
          flash[:warning] = message 
	  redirect_to root_url
        end # 
      end  # first if
    end   # respond_to
  end     # def
  
  def login
    params.permit(:login, :password, :authenticity_token, :commit)
    user = User.find_by(login: params[:login])
    if request.post? 
      #if user && user.authenticate(params[:password]) 
      if user && user.authenticate(params[:password])
        if user.activated?
	  #params[:remember_me] == '1' ? User.remember(user) : User.forget
	  session[:user_id] = user.id
          redirect_to events_url
	  #redirect_back_or user
	else
	  message  = t"Account not activated." 
	  message += t"Check your email for the activation link." 
	  flash[:notice] = message 
	  redirect_to root_url 
        end
          
      else
        flash.now[:notice] = t('Invalid login/password combination')
      end
    end
  end
  
  def logout
    session[:user_id] = nil
    
    respond_to do |format|
      format.html { redirect_to :root  }
      format.xml  { head :ok }
    end
  end
  
end
