'use strict'

/*
 * THE DASHBOARD CONTROLLER
 * ------------------------------------
 * Controls the DashBoard
 */

App.controller('GraphController', ['$http', 
	function($http){

	var vm = this;

	$http.get('/stats/daily')
	.success(function(data){
		vm.daily = data;
		console.log('daily stat retrieval successful');
	}).error(function(){
		console.log('daily stat retrieval unsuccessful');
	})

	$http.get('/stats/category')
	.success(function(data){
		vm.category = data;
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