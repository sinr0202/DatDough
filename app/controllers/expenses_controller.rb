class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [:show, :update, :destroy]
  
  def index
    
    per_page = 30
    page = params[:page]
    start_date = params[:start_date]
    end_date = params[:end_date]

    if (start_date.nil? || start_date.empty?) && (end_date.nil? || end_date.empty?)
      expenses = Expense.where(user: current_user)
        .paginate(page: page, per_page: per_page)
        .order(date: :desc, created_at: :desc)
    elsif !start_date.empty? && end_date.empty?
      expenses = Expense.where(user: current_user)
        .transferred_after(start_date).paginate(page: page, per_page: per_page)
        .order(date: :desc, created_at: :desc)
    elsif start_date.empty? && !end_date.empty?
      expenses = Expense.where(user: current_user)
        .transferred_before(end_date).paginate(page: page, per_page: per_page)
        .order(date: :desc, created_at: :desc)
    else
      expenses = Expense.where(user: current_user)
        .transferred_after(start_date)
        .transferred_before(end_date).paginate(page: page, per_page: per_page)
        .order(date: :desc, created_at: :desc)
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
  
  private 
  
  def owner?
    @expense.user == current_user
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:date, :amount, :description, :category, :payment_method)
  end
end
