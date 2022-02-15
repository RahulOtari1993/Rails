class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
          
  has_many :players
  has_many :achievements
  has_many :posts
  has_many :comments

  enum role: [ :player, :user, :admin]
  after_initialize :set_default_role, :if => :new_record?
    def set_default_role
      self.role ||= :player
    end    
end


