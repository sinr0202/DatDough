class Expense < ActiveRecord::Base

  before_validation :set_type

  belongs_to :user

  scope :logged_before, ->(created_at) { where("created_at <= ?", created_at) }
  scope :transferred_before, ->(date) { where("date <= ?", date) }
  scope :transferred_after, ->(date) { where("date >= ?", date) }
  
  validates :date, :amount, :description, presence: true
  #reduce category
  enum category: [:work, :sales, :rebate, :other_income, :groceries, :dining, :living, :leisure, :electronics, :health, :fashion, :education, :service, :donation, :transportation, :automobile, :parking]
  enum payment_method: [:cash, :debit, :credit, :cryptocoin, :cheque]
  enum transaction_type: [:income, :expense]

  def net
    Expense.logged_before(created_at).sum(:amount)
  end
  
  def day_net
    Expense.transferred_before(date).sum(:amount)
  end

  private  

  def set_type
    income = ["work", "sales", "rebate", "other_income"]
    if income.include? self.category
      self.transaction_type = "income"
      self.amount = self.amount.abs
    else
      self.transaction_type = "expense"
      self.amount = -1 * self.amount.abs
    end
  end
end

  