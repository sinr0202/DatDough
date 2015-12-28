'use strict'

/*
 * THE DASHBOARD CONTROLLER
 * ------------------------------------
 * Controls the DashBoard
 */


App.controller('DashboardController', ['Expense', 'Options',
 	function(Expense, Options){

	var vm = this;
	
	//ON LOAD
	Options.getCategory()
	.then(function(data){
		console.log(data);
		vm.categories = data;
		console.log(vm.categories);
	}, function(){
		alert("there is an issue");
	});


	vm.new = function(){
		vm.expense = {
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