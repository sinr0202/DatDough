class ImportController < ApplicationController
  before_action :authenticate_user!

  def new
    render layout: nil
  end

  def csv
    file = params[:file]
    begin 
      CSV.foreach(file.path, headers: true) do |row|

        expense = Expense.new(row.to_hash)
        expense.user = current_user
        expense.save
      end
    rescue Exception => e
      render json: {error: e.message}, status: :unprocessable_entity
    else
      render json: {}, status: :ok
    end
  end
end
