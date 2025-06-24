class AbilityPermission < ApplicationRecord
  has_many :role_abilities, dependent: :destroy
  has_many :roles, through: :role_abilities
  
  validates :action, presence: true, inclusion: { in: %w[read create update destroy manage index show new edit process_order] }
  validates :subject, presence: true
  validates :action, uniqueness: { scope: :subject }
  
  scope :for_subject, ->(subject) { where(subject: subject) }
  
  # PaperTrail for audit logging
  has_paper_trail
end
