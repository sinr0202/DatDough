'use strict'

/*
 * THE TABLE CONTROLLER
 * ------------------------------------
 * Controls the Table
 */

App.controller('TableController', ['Expense',
	function(Expense){

	var vm = this;
	vm.page = 1;
	vm.expenses = [];
	vm.showSearch = false;

	vm.searchToggle = function(){
		vm.showSearch = !vm.showSearch;
	};

	vm.loadNextExpense = function(){
		Expense.query({page: vm.page})
		.then(function(expenses){
			vm.page += 1
			vm.expenses = vm.expenses.concat(expenses)
		})};

	vm.edit = function(index){
		console.log(index) 
	}

	vm.loadNextExpense()

}]);
