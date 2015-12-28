class ApiController < ApplicationController

	def categories
		options = Expense.categories.keys
		render json: options.to_json
	end

	def paymethods
		options = Expense.payment_methods.keys
		render json: options.to_json
	end
end