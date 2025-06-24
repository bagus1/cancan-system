class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
  
  validates :user_id, uniqueness: { scope: :role_id }
  
  # PaperTrail for audit logging
  has_paper_trail
end
