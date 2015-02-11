class Expense < ActiveRecord::Base
  validates :date, :price, :desciption, presence: true
 
end
