class Expense < ActiveRecord::Base
  scope :logged_before, ->(created_at) { where("created_at <= ?", created_at) }
  scope :transferred_before, ->(date) { where("date <= ?", date) }
  validates :date, :amount, :description, presence: true
  enum category: [ "Personal & Household Expenses", "Professional & Financial Services", "Retail and Grocery", "Transportation", "Hotels, Entertainment, and Recreation", "Restaurants", "Home & Office Improvement", "Health & Education", "Cash Advances and Balance Transfers", "Foreign Currency Transactions", "Other Transactions" ]
  
  def net
    Expense.logged_before(created_at).sum(:amount)
  end
  
  def day_net
    Expense.transferred_before(date).sum(:amount)
  end
end

  