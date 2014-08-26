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
  
  #private
  
  def set_status_to_pending
    status ||= 'PENDING'
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
      .where(cat_id: cat_id)
      .where.not(id: id)
      .where(
       range_where,
        start_date,
        end_date
      )
  end
  
  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end
end