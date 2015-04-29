class ImportController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def csv
    file = params[:file]
    CSV.foreach(file.path, headers: true) do |row|
      expense = Expense.new(row.to_hash)
      expense.user = current_user
      unless expense.save
        redirect_to root_url, notice: "Expense import failed!"
      end
    end
    redirect_to root_url, notice: "Expense imported"
  end
end
