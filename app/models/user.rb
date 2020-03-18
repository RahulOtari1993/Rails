class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  enum role: [:admin, :participant]

  ## Associations
  belongs_to :organization

  ## Validations
  validates :first_name, :last_name, :organization_id, presence: true

  validates_presence_of :password, if: :password_required?

  def password_required?
    # !persisted? || !password.nil? || !password_confirmation.nil?
    confirmed? ? super : false
  end
end
