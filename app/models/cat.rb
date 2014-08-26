class Cat < ActiveRecord::Base
  COLORS = ['Black', 'White', 'Brown', 'Grey', 'Orange']
  
  validates :age, numericality: true
  validates :color, inclusion: {
    in: COLORS
  }  
  validates :sex, inclusion: {
    in: ['M', 'F']
  }
  validates :age, :birth_date, :color, :name, :sex, :description, presence: true
end
