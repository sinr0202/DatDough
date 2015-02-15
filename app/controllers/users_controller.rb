class UsersController < ApplicationController
  
  def show
    @expenses = current_user.expenses
  end
  
end
