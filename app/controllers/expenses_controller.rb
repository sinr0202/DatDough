class ExpensesController < ApplicationController
  before_action :set_expense, only: [:edit, :update, :delete]
  def index
    @expenses = Expense.all
  end
  
  def new
    @expense = Expense.new
  end
  
  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      redirect_to expenses_path, notice: "new record created"
    else
      render :new
    end
  end
  
  private
  
  def expense_params
    params.require(:expense).permit(:date, :amount, :description, :category)
  end
end
