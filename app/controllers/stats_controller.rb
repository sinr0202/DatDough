class StatsController < ApplicationController

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
  
end
