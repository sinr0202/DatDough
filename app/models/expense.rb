class Expense < ActiveRecord::Base

  belongs_to :user

  scope :logged_before, ->(created_at) { where("created_at <= ?", created_at) }
  scope :transferred_before, ->(date) { where("date <= ?", date) }
  validates :date, :amount, :description, presence: true
  enum category: [:grocery, :restaurant, :work, :education, :eletronic, :fashion, :financial, :health, :household, :leisure, :rebate, :transportation, :others]
  enum payment_method: [:cash, :debit, :credit, :cryptocoin, :cheque]
  enum transaction_type: [:expense, :income, :gift, :donation]

  def net
    Expense.logged_before(created_at).sum(:amount)
  end
  
  def day_net
    Expense.transferred_before(date).sum(:amount)
  end
end

  