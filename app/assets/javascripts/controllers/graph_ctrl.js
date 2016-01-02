'use strict'

/*
 * THE GRAPH CONTROLLER
 * ------------------------------------
 * Controls the Graph
 */

App.controller('GraphController', ['$http', 
	function($http){

	var vm = this;
	vm.income = {}
	vm.expense = {}

	$http.get('/stats/daily')
	.success(function(data){
		vm.daily = data;
		console.log('daily stat retrieval successful');
	}).error(function(){
		console.log('daily stat retrieval unsuccessful');
	})

	$http.get('/stats/category')
	.success(function(data){
		vm.income.data = data.income;
		vm.expense.data = data.expense;
		vm.categoryOption = {
            chart: {
                type: 'pieChart',
                height: 500,
                x: function(d){return d.key;},
                y: function(d){return d.y;},
                showLabels: false,
                duration: 500,
                labelThreshold: 0.01,
                labelSunbeamLayout: true,
                legend: {
                    margin: {
                        top: 5,
                        right: 35,
                        bottom: 5,
                        left: 0
                    }
                }
            }
        };


		console.log('category stat retrieval successful');
	}).error(function(){
		console.log('category stat retrieval unsuccessful');
	})

	$http.get('/stats/monthly')
	.success(function(data){
		vm.monthly = data;
		console.log('monthly stat retrieval successful');
	}).error(function(){
		console.log('monthly stat retrieval unsuccessful');
	})

}])