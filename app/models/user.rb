class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, :session_token, uniqueness: true
  
  #after_initialize :ensure_session_token
  
  has_many(
    :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id
  )
  
  has_many(
    :rental_requests,
    class_name: 'CatRentalRequest',
    foreign_key: :user_id,
    primary_key: :id
  )
  
  has_many(
    :sessions,
    class_name: 'Session',
    foreign_key: :user_id,
    primary_key: :id
  )
  
  def self.find_by_username(user_name)
    find_by(user_name: user_name)
  end
  
  def self.find_by_credentials(user_name, password)
    user = find_by_username(user_name)
    
    (!user.nil? && user.is_password?(password)) ? user : nil
  end
  
  def self.find_by_token(token)
    session = Session.find_by_token(token)
    user = session.user rescue nil
    
    user.session_id = session.id unless user.nil?
    
    user
    
    # find_by(session_token: token)
  end
  
  def session_id=(id)
    @session_id = id
  end
  
  def session_id
    @session_id
  end
  
  def password=(password)
    self.update(password_digest: BCrypt::Password.create(password))
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  # def ensure_session_token
  #   self.session_token ||= SecureRandom::urlsafe_base64(16)
  # end
  
  # def reset_session_token!
  #   self.session_token = SecureRandom::urlsafe_base64(16)
  #   self.save!
  #   self.session_token
  # end
end
