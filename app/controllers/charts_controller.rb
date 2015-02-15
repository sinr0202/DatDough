class ChartsController < ApplicationController
  def daily_expense
    # daily_balance_array = []
    # all_transactions = Expense.all
    #
    # all_transactions.group_by_day(:date).count.each do |data|
    #   total_amount = all_transactions.transferred_before(data[0]).sum(:amount)
    #   daily_balance_array << data[0] << total_amount
    # end
    # chart_hash = Hash[*daily_balance_array]
    
    
    daily_expenses_hash = Expense.group(:date).order(date: :asc).sum(:amount)
    render json: dailify(daily_expenses_hash)
  end
  
  def net
    daily_expenses_hash = Expense.group(:date).order(date: :asc).sum(:amount)
    daily_expense = dailify(daily_expenses_hash)
    result_hash = {}
    net_array = []
    daily_expense.values.inject(0) do |sum, n|
      x = sum + n
      net_array << x
      x
    end
    daily_expense.each_with_index do |item, index|
      result_hash[item[0]] = net_array[index]
    end
    render json: result_hash
  end
  
  private 
  
  def dailify(daily_expenses_hash)
    #daily_expenses_hash should be ordered by date
    daily_expenses_arr = daily_expenses_hash.to_a
    min_date = daily_expenses_arr.first[0]
    max_date = daily_expenses_arr.last[0]
    # total_days = (max_date - min_date).to_i + 1
    result_hash = {}
    (min_date..max_date).each do |day|
      result_hash[day] = 0
    end
    daily_expenses_hash.each do |item|
      # can be changed to += to support sum daily transacations
      result_hash[item[0]] = item[1]
    end
    result_hash
  end
end
