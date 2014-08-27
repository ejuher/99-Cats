class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validates :status, inclusion: { in: ['PENDING', 'APPROVED', 'DENIED'] }
  validate :no_other_rentals_approved_in_range
  
  after_initialize :set_status_to_pending
  
  belongs_to(
    :cat,
    class_name: 'Cat',
    foreign_key: :cat_id,
    primary_key: :id
  )
  
  has_one(
    :cat_owner,
    through: :cat,
    source: :owner
  )
  
  belongs_to(
    :user,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )
  
  def approve!
    self.class.transaction do
      self.status = 'APPROVED'
      self.save!
      overlapping_pending_requests.update_all(status: 'DENIED')
    end
  end
  
  def deny!
    self.status = 'DENIED'
    self.save!
  end
  
  def pending?
    self.status == "PENDING"
  end
  
  private
  
  def set_status_to_pending
    self.status ||= 'PENDING'
  end
  
  def no_other_rentals_approved_in_range
    unless overlapping_approved_requests.empty?
      errors[:start_date] << "Rental is already approved for this date range"
    end
  end
  
  def overlapping_requests
    range_where = 
    '(? < end_date) AND (? > start_date)'
    
    self.class
      .where(cat_id: self.cat_id)
      .where.not(id: self.id)
      .where(
       range_where,
        start_date,
        end_date
      )
  end
  
  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end
  
  def overlapping_pending_requests
    overlapping_requests.where(status: 'PENDING')
  end
end