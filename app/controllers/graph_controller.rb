class GraphController < ApplicationController

	def bar
		start_date = params[:start_date]
		end_date = params[:end_date]
		
		expenses = filter_dates(start_date,end_date)
					.where(transaction_type: 1) 		#expense only
					.group(:date).order(date: :asc).sum(:amount)
		expenses = fill_zero_days(expenses)
		render json: expenses, status: :ok
	end

	def pie
		start_date = params[:start_date]
		end_date = params[:end_date]

		expenses = filter_dates(start_date,end_date)
					.where(transaction_type: 1) 		#expense only
					.group(:category).sum(:amount)
		categories = Expense.categories
		expenses.transform_keys!{ |val| categories.key(val) }
		render json: expenses, status: :ok
	end


	private

	def filter_dates(start_date, end_date)
		expenses = current_user.expenses

		unless start_date.nil? || start_date.empty?
			expenses = expenses.transferred_after(start_date)
		end
		unless end_date.nil? || end_date.empty?
			expenses = expenses.transferred_before(end_date)
		end

		return expenses
	end

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

end