class StatsController < ApplicationController

  def daily
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

  def category
  	if (params[:start_date].nil? || params[:start_date].empty?) && (params[:end_date].nil? || params[:end_date].empty?)
  	  puts 'helloo'
      category_hash = Expense.where(user: current_user).group(:category).order(category: :asc).sum(:amount)
    elsif !params[:start_date].empty? && params[:end_date].empty?
      category_hash = Expense.where(user: current_user).transferred_after(params[:start_date]).group(:category).order(category: :asc).sum(:amount)
    elsif params[:start_date].empty? && !params[:end_date].empty?
      category_hash = Expense.where(user: current_user).transferred_before(params[:end_date]).group(:category).order(category: :asc).sum(:amount)
    else
      category_hash = Expense.where(user: current_user).transferred_before(params[:end_date]).transferred_after(params[:start_date]).group(:category).order(category: :asc).sum(:amount)
    end

    result_hash = {}
    puts category_hash
    categories = Expense.categories
    categories.each do |category,val|
    	result_hash[category] = category_hash[val].to_i if category_hash[val]
	end

  	render json: result_hash, status: :ok
  end

  private 
  
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
end
