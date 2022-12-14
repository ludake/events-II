class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation
    @greeting = "Hi"

    mail to: "[email protected]"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "[email protected]"
  end

  def account_activation(user) 
    @user = user 
    mail to: user.email, subject: "帐号激活" 
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "密码重置"
  end

end
