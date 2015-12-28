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
		vm.categories = data;
	}, function(){
		alert("Can't retrieve category");
	});

	Options.getPaymentMethod()
	.then(function(data){
		vm.paymethod = data;
	}, function(){
		alert("Can't retrieve paymethod");
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