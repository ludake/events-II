require 'bcrypt'

class User < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader
  
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  
  has_many :events,
#           .order("occurs_on DESC"),
#           .order("title ASC"),
           :dependent => :destroy
  has_many :registrations,
           :dependent => :destroy
  has_many :activities, :through => :registrations, :source => :event
  
  has_secure_password  
  
  validates_presence_of    :login
  validates_length_of      :login,     :within => 3..50
  validates_uniqueness_of  :login,     :case_sensitive => false
  validates_format_of      :login,     :with => /\A[\w.-]+\z/i
  
  validates                :email,     :uniqueness => { case_sensitive: false }, :length => { maximum: 255 }
  validates_presence_of    :email
  validates_format_of      :email,     :with => /\A[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}\z/i
  
  #validates_presence_of     :password, :if => :password_required?
  #validates_length_of       :password, :within => 6..64 , :if => :password_required?
  #validates_confirmation_of :password, :if => :password_required?
  
  validates :password, presence: true, length: { minimum: 6 }
  
  # authenticated? 加入了激活令牌的版本
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end  
   
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.remember
    self.remember_token = User.new_token 
    update(:remember_digest, User.digest(remember_token))  
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)

  end

  def User.forget
    update(:remember_digest, nil)
  end

  def activate
    moment = Time.zone.now
    update_attribute(:activated, true) 
    update_attribute(:activated_at, moment.localtime)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end  
  
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end 
  # 设置密码重设相关的属性
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # 发送密码重设邮件
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end  

  private

    # 把电子邮件地址转换成小写
    def downcase_email
      self.email = email.downcase 
    end

    # 创建并赋值激活令牌和摘要
    def create_activation_digest
      self.activation_token  = User.new_token 
      self.activation_digest = User.digest(activation_token) 
    end

   
#  validates_acceptance_of :terms_of_service
end
