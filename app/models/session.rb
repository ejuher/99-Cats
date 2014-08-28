class Session < ActiveRecord::Base
  validates :user_id, :token, :device_description, :ip, presence: true
  validates :token, uniqueness: true
  
  after_initialize :ensure_session_token

  
  belongs_to(
    :user,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )
  
  def self.add_token_for_user(user, user_agent, ip)
    user_agent = user_agent.match(/\S+ \([^\)]+\)/)[0]
    
    new_token = generate_token
    
    self.create!(
      user_id: user.id, token: new_token, device_description: user_agent, ip: ip
    )
    
    new_token
  end
  
  def self.generate_token
    SecureRandom::urlsafe_base64(16)
  end 
  
  private
  
  def ensure_session_token
    self.token ||= SecureRandom::urlsafe_base64(16)
  end
end