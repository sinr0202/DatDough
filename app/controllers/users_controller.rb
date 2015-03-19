class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @expenses = current_user.expenses.order(date: :desc)
  end
  
end
