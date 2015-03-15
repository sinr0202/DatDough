class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @expenses = current_user.expenses
  end
  
end
