'use strict'

/*
 * THE TABLE CONTROLLER
 * ------------------------------------
 * Controls the Table
 */

App.controller('TableController',
	function(Expense, $scope){

	var vm = this;
	vm.page = 1;
	vm.expenses = [];
	vm.showSearch = false;
	vm.loading = false;

	vm.searchToggle = function(){
		vm.showSearch = !vm.showSearch;
	};

	vm.loadNextExpense = function(){
		vm.loading = true;
		Expense.query({page: vm.page})
		.then(function(expenses){
			vm.page += 1
			vm.expenses = vm.expenses.concat(expenses)
			vm.loading = false;
		})};
		

	vm.edit = function(index){
		console.log(index) 
	}

	vm.loadNextExpense()

	$scope.$on('scrolling', function (event, data) {
		console.log('scrolled to bottom');
		if (!vm.loading){
			vm.loadNextExpense();
		}
	});
});
