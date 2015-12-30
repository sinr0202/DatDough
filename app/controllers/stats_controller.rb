class StatsController < ApplicationController

  def daily
    daily_hash = daily_net(:date)
    result = fill_zero_days(daily_hash)
    
    render json: result, status: :ok
  end

  def category
    category_hash = daily_net(:category)
    categories = Expense.categories
    category_hash.transform_keys!{ |val| categories.key(val) }

    income_hash = {}
    expense_hash = {}
    category_hash.each do |category, val|
      if val > 0
        income_hash[category.gsub(/_/, ' ').downcase.capitalize] = val
      else
        expense_hash[category.gsub(/_/, ' ').downcase.capitalize] = val.abs
      end
    end

    result = {income: income_hash, expense: expense_hash}

  	render json: result, status: :ok
  end

  def monthly
    expenses = current_user.expenses
    income_hash = {}
    expense_hash = {}

    expenses.each do |e|
      if e.transaction_type == "expense"
        expense_hash[e.date.year] = Array.new(12, 0) unless expense_hash.key?(e.date.year)
        expense_hash[e.date.year][e.date.month-1] += e.amount
      else
        income_hash[e.date.year] = Array.new(12, 0) unless income_hash.key?(e.date.year)
        income_hash[e.date.year][e.date.month-1] += e.amount
      end
    end

    result = {income: income_hash,expense: expense_hash}

    render json: result, status: :ok
  end

  def most
    date = Date.today - 300 # needs to be adjusted accordingly.
    limit = 3
    
    expenses = current_user.expenses.transferred_after(date)

    categories = expenses.group(:category)
                .order('count_id desc')
                .count(:id)
                .map{|k,v|[Expense.categories.key(k),v]}
                .first(limit).to_h
    paymethods = expenses.group(:payment_method)
                .order('count_id desc')
                .count(:id)
                .map{|k,v|[Expense.payment_methods.key(k),v]}
                .first(limit).to_h
    descriptions = expenses.group(:description)
                .order('count_id desc')
                .count(:id).first(limit).to_h

    result = {categories: categories, paymethods: paymethods, descriptions: descriptions}

    render json: result, status: :ok
  end

  private 
  
  def fill_zero_days(daily_hash)
    daily_expenses_arr = daily_hash.to_a
    return [] if daily_expenses_arr.empty?
    min_date = daily_expenses_arr.first[0]
    max_date = daily_expenses_arr.last[0]

    result = []
    (min_date..max_date).each do |day|
      if daily_hash.key?(day)
        result << [day.to_formatted_s(:long), daily_hash[day].to_f]
      else
        result << [day.to_formatted_s(:long), 0]
      end
    end

    return result
  end

  def daily_net(group_by)
    expenses = current_user.expenses
    start_date = params[:start_date]
    end_date = params[:end_date]
    if (start_date.nil? || start_date.empty?) && (end_date.nil? || end_date.empty?)
      daily_hash = expenses
    elsif !start_date.empty? && end_date.empty?
      daily_hash = expenses.transferred_after(start_date)
    elsif start_date.empty? && !end_date.empty?
      daily_hash = expenses.transferred_before(end_date)
    else
      daily_hash = expenses.transferred_before(end_date)
                           .transferred_after(start_date)
    end

    return daily_hash.group(group_by).order(group_by => :asc).sum(:amount)
  end
end
