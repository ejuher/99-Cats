class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: ['PENDING', 'APPROVED', 'DENIED'] }
  validate :no_other_rentals_approved_in_range
  
  after_initialize :set_status_to_pending
  
  belongs_to(
    :cat,
    class_name: 'Cat',
    foreign_key: :cat_id,
    primary_key: :id
  )
  
  def approve!
    self.class.transaction do
      self.status = 'APPROVED'
      debugger
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
  
  # private
  
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
      '(? BETWEEN start_date AND end_date) OR (? BETWEEN start_date AND end_date)'
    
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