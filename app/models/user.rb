class User < ActiveRecord::Base
  has_secure_password
  validates :full_name, presence: true
  validates :nickname, presence: true
  validates :email_address, presence: true, uniqueness: true, email: true
  validates :password, presence: true, :on => :create
  validates :password, :length => { :minimum => 8 }, :allow_blank => false, :on => :create
  validates :password, :length => { :minimum => 8 }, :allow_blank => true, :on => :update
end