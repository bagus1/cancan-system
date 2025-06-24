class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
  has_many :role_abilities, dependent: :destroy
  has_many :ability_permissions, through: :role_abilities
  
  validates :name, presence: true, uniqueness: true
  
  # PaperTrail for audit logging
  has_paper_trail
end
