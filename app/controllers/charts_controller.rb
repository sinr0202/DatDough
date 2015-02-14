class ChartsController < ApplicationController
  def daily_balance
    daily_balance_array = []
    Expense.group_by_day(:date).count.each do |data|
      total_amount = Expense.transferred_before(data[0]).sum(:amount)
      daily_balance_array << data[0] << total_amount
    end
    chart_hash = Hash[*daily_balance_array]
    render json: chart_hash
  end
end
