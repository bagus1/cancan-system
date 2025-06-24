class Order < ApplicationRecord
  belongs_to :user
  
  validates :total, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending processing completed cancelled] }
  
  # PaperTrail for audit logging
  has_paper_trail
end
