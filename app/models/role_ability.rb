class RoleAbility < ApplicationRecord
  belongs_to :role
  belongs_to :ability_permission
  
  validates :role_id, uniqueness: { scope: :ability_permission_id }
  
  # PaperTrail for audit logging
  has_paper_trail
end
