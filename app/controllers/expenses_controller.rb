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
