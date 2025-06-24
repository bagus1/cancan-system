class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Authorization relationships
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :orders, dependent: :destroy
  
  # PaperTrail for audit logging
  has_paper_trail
  
  def has_role?(role_name)
    roles.exists?(name: role_name)
  end
  
  def admin?
    has_role?('Admin')
  end
end
