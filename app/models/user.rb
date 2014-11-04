class User < ActiveRecord::Base
  has_secure_password

  validates :email_address, presence: true, uniqueness: true, email: true
  validates :password, presence: true, :on => :create
  validates :password, length: { minimum: 8 }, :unless => 'password.blank?'

end
