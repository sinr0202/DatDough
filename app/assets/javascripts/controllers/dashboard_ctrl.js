'use strict'

/*
 * THE DASHBOARD CONTROLLER
 * ------------------------------------
 * Controls the DashBoard
 */


App.controller('DashboardController', ['Expense', function(Expense){

	var vm = this;

	vm.new = function(){
		vm.expense={
			date: new Date(),
			category: 'dining', // should get the most probable one
			payment_method: 'cash' // also should get most probable
		}
	}

	vm.cancel = function(){
		console.log('cancel')
	}

	vm.submit = function(){
		console.log(vm.expense)
		new Expense(vm.expense).create()
		.then(function(data){
			alert('submission successful');
		}, function(error){
			alert('submission unsuccessful')
		})
	}

	vm.new()
}]);