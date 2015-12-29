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
      category_hash = Expense.where(user: current_user)
                      .group(:category)
                      .order(category: :asc)
                      .sum(:amount)
    elsif !params[:start_date].empty? && params[:end_date].empty?
      category_hash = Expense.where(user: current_user)
                      .transferred_after(params[:start_date])
                      .group(:category)
                      .order(category: :asc)
                      .sum(:amount)
    elsif params[:start_date].empty? && !params[:end_date].empty?
      category_hash = Expense.where(user: current_user)
                      .transferred_before(params[:end_date])
                      .group(:category)
                      .order(category: :asc)
                      .sum(:amount)
    else
      category_hash = Expense.where(user: current_user)
                      .transferred_before(params[:end_date])
                      .transferred_after(params[:start_date])
                      .group(:category)
                      .order(category: :asc)
                      .sum(:amount)
    end

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

  	render json: {income: income_hash, expense: expense_hash}, status: :ok
  end

  def monthly
    expenses = current_user.expenses
    net_hash = {}
    income_hash = {}
    expense_hash = {}

    expenses.each do |e|
      net_hash[e.date.year] = Array.new(12, 0) unless net_hash.key?(e.date.year)
      net_hash[e.date.year][e.date.month-1] += e.amount
      if e.transaction_type == "expense"
        expense_hash[e.date.year] = Array.new(12, 0) unless expense_hash.key?(e.date.year)
        expense_hash[e.date.year][e.date.month-1] += e.amount
      else
        income_hash[e.date.year] = Array.new(12, 0) unless income_hash.key?(e.date.year)
        income_hash[e.date.year][e.date.month-1] += e.amount
      end
    end

    avg_expense_hash = {}
    count = 0
    expense_hash.each do |year, months|
      sum = months.inject(BigDecimal.new("0")) {|sum,x|
        count += 1 unless x.zero?
        sum + x
      }
      if count == 0
        avg_expense_hash[year] = 0
      else
        avg_expense_hash[year] = sum / count
      end
    end

    avg_income_hash = {}
    count = 0
    income_hash.each do |year, months|
      sum = months.inject(BigDecimal.new("0")) {|sum,x|
        count += 1 unless x.zero?
        sum + x
      }
      if count == 0
        avg_income_hash[year] = 0
      else
        avg_income_hash[year] = sum / count
      end
    end

    result = {net: net_hash,
             expense: expense_hash,
             income: income_hash,
             avg_expense: avg_expense_hash,
             avg_income: avg_income_hash}

    render json: result, status: :ok
  end

  def most
    date = Date.today - 300
    limit = 3
    
    expenses = Expense.where(user: current_user).transferred_after(date)

    categories = expenses.group(:category)
                .order('count_id desc')
                .count(:id)
                .map{|k,v|[Expense.categories.key(k),v]}.first(limit).to_h
    paymethods = expenses.group(:payment_method)
                .order('count_id desc')
                .count(:id)
                .map{|k,v|[Expense.payment_methods.key(k),v]}.first(limit).to_h
    descriptions = expenses.group(:description)
                .order('count_id desc')
                .count(:id).first(limit).to_h
    render json: {categories: categories, paymethods: paymethods, descriptions: descriptions}
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
