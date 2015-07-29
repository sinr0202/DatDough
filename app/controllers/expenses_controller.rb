class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [:show, :update, :destroy]
  
  def index
    if (params[:start_date].nil? || params[:start_date].empty?) && (params[:end_date].nil? || params[:end_date].empty?)
      expenses = Expense.where(user: current_user).paginate(page: params[:page], per_page: 30).order(date: :desc, created_at: :desc)
    elsif !params[:start_date].empty? && params[:end_date].empty?
      expenses = Expense.where(user: current_user).transferred_after(params[:start_date]).paginate(page: params[:page], per_page: 30).order(date: :desc, created_at: :desc)
    elsif params[:start_date].empty? && !params[:end_date].empty?
      expenses = Expense.where(user: current_user).transferred_before(params[:end_date]).paginate(page: params[:page], per_page: 30).order(date: :desc, created_at: :desc)
    else
      expenses = Expense.where(user: current_user).transferred_after(params[:start_date]).transferred_before(params[:end_date]).paginate(page: params[:page], per_page: 30).order(date: :desc, created_at: :desc)
    end
    render json: expenses.to_json
  end

  def new
    @expense = Expense.new
  end
  
  def create
    @expense = Expense.new(expense_params)
    @expense.user = current_user
    if @expense.save
      render json: @expense.to_json, status: :ok
    else
      render json: @expense.errors.full_messages.to_json, status: :unprocessable_entity
    end
  end
  
  def show
    if owner?
      render json: @expense.to_json, status: :ok
    else
      render json: {message: "access denied"}, status: :unauthorized
    end
  end

  def update
    if owner?
      if @expense.update(expense_params)
        render json: @expense.to_json, status: :ok
      else
        render json: @expense.errors.full_messages.to_json, status: :unprocessable_entity
      end
    else
      render json: {message: "access denied"}, status: :unauthorized
    end
  end

  def destroy
    @expense.destroy
    render json: {}, status: :ok
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
    if (params[:start_date].nil? || params[:start_date].empty?) && (params[:end_date].nil? || params[:end_date].empty?)
      daily_expenses_hash = Expense.where(user: current_user).group(:date).order(date: :asc).sum(:amount)
    elsif !params[:start_date].empty? && params[:end_date].empty?
      daily_expenses_hash = Expense.where(user: current_user).transferred_after(params[:start_date]).group(:date).order(date: :asc).sum(:amount)
    elsif params[:start_date].empty? && !params[:end_date].empty?
      daily_expenses_hash = Expense.where(user: current_user).transferred_before(params[:end_date]).group(:date).order(date: :asc).sum(:amount)
    else
      daily_expenses_hash = Expense.where(user: current_user).transferred_before(params[:end_date]).transferred_after(params[:start_date]).group(:date).order(date: :asc).sum(:amount)
    end
      
    render json: dailify(daily_expenses_hash), status: :ok
  end
  
  def net
    if (params[:start_date].nil? || params[:start_date].empty?) && (params[:end_date].nil? || params[:end_date].empty?)
      daily_hash = Expense.where(user: current_user).group(:date).order(date: :asc).sum(:amount)
    elsif !params[:start_date].empty? && params[:end_date].empty?
      daily_hash = Expense.where(user: current_user).transferred_after(params[:start_date]).group(:date).order(date: :asc).sum(:amount)
    elsif params[:start_date].empty? && !params[:end_date].empty?
      daily_hash = Expense.where(user: current_user).transferred_before(params[:end_date]).group(:date).order(date: :asc).sum(:amount)
    else
      daily_hash = Expense.where(user: current_user).transferred_before(params[:end_date]).transferred_after(params[:start_date]).group(:date).order(date: :asc).sum(:amount)
    end

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
  
  def owner?
    @expense.user == current_user
  end


  def dailify(daily_hash)
    #daily_hash should be ordered by date
    daily_expenses_arr = daily_hash.to_a
    return [] if daily_expenses_arr.empty?
    min_date = daily_expenses_arr.first[0]
    max_date = daily_expenses_arr.last[0]
    # total_days = (max_date - min_date).to_i + 1
    result_arr = []
    (min_date..max_date).each do |day|
      if daily_hash.key?(day)
        result_arr << [day.to_formatted_s(:long), daily_hash[day].to_f]
      else
        result_arr << [day.to_formatted_s(:long), 0]
      end
    end
    result_arr
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:date, :amount, :description, :category, :payment_method)
  end
end
