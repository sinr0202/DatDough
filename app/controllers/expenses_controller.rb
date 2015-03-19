class ExpensesController < ApplicationController
  before_action :authenticate_user!
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
      redirect_to dashboard_url, notice: "new record created"
    else
      render :new
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    redirect_to dashboard_url, notice: "transaction deleted"
  end
  
  def daily
    # daily_balance_array = []
    # all_transactions = Expense.all
    #
    # all_transactions.group_by_day(:date).count.each do |data|
    #   total_amount = all_transactions.transferred_before(data[0]).sum(:amount)
    #   daily_balance_array << data[0] << total_amount
    # end
    # chart_hash = Hash[*daily_balance_array]
    
    daily_expenses_hash = Expense.where(user: current_user).group(:date).order(date: :asc).sum(:amount)
    render json: dailify(daily_expenses_hash), status: :ok
  end
  
  def net
    daily_hash = Expense.where(user: current_user).group(:date).order(date: :asc).sum(:amount)
    daily_arr = dailify(daily_hash)
    result_arr = []
    daily_arr.inject(0) do |sum, n|
      day = n[0]
      day_net = n[1]
      sum = sum + day_net
      result_arr << [day, sum.round(2)]
      sum
    end

    render json: result_arr, status: :ok
  end
  
  private 
  
  def dailify(daily_hash)
    #daily_hash should be ordered by date
    daily_expenses_arr = daily_hash.to_a
    min_date = daily_expenses_arr.first[0]
    max_date = daily_expenses_arr.last[0]
    # total_days = (max_date - min_date).to_i + 1
    result_arr = []
    (min_date..max_date).each do |day|
      if daily_hash.key?(day)
        result_arr << [day.to_time.to_i, daily_hash[day].to_f]
      else
        result_arr << [day.to_time.to_i, 0]
      end
    end
    result_arr
  end

  def expense_params
    params.require(:expense).permit(:date, :amount, :description, :category)
  end
end
