'use strict'

/*
 * THE GRAPH CONTROLLER
 * ------------------------------------
 * Controls the Graph
 */

App.controller('GraphController',
	function($scope, $mdDialog, $mdMedia, $http){

	var vm = this;
	vm.barData = [];
	vm.pieData = [];
	vm.endDate = new Date()
	vm.startDate = new Date()
	vm.startDate.setDate(vm.startDate.getDate()-30)

	vm.barOptions = {
		chart: {
			type: 'multiBarChart',
			height: 450,
			margin : {
				top: 20,
				right: 100,
				bottom: 45,
				left: 100
			},
			clipEdge: true,
			duration: 500,
			stacked: true,
			xAxis: {
				axisLabel: 'Date (MM/dd/yyyy)',
				showMaxMin: false,
				tickFormat: function(d){
					return d3.time.format('%x')(new Date(d));
				}
			},
			yAxis: {
				axisLabel: 'Dollars ($)',
				tickFormat: function(d){
					return d3.format(',.1f')(d);
				}
			}
		}
	};

	vm.pieOptions = {
		chart: {
			type: 'pieChart',
			height: 500,
			x: function(d){return d.key;},
			y: function(d){return d.y;},
			showLabels: true,
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

	var DialogController = function($scope, $mdDialog, startDate, endDate) {
		$scope.startDate = startDate;
		$scope.endDate = endDate;

		$scope.cancel = function() {
			$mdDialog.cancel();
		};

		$scope.answer = function() {
			$mdDialog.hide({
				startDate: $scope.startDate,
				endDate: $scope.endDate
			});
		};
	}
	
	vm.showDialog = function(ev){
		var useFullScreen = ($mdMedia('sm') || $mdMedia('xs'))  && $scope.customFullscreen;
		$mdDialog.show({
			controller: DialogController,
			templateUrl: 'date',
			parent: angular.element(document.body),
			targetEvent: ev,
			clickOutsideToClose:true,
			fullscreen: useFullScreen,
			locals: {
				startDate: vm.startDate,
				endDate: vm.endDate
			}
		}).then(function(data) {
			console.log('dialog data retrieval successful');
			vm.startDate = data.startDate;
			vm.endDate = data.endDate;
			vm.updateGraphs();
		}, function() {
			console.log('dialog cancled');
		});
		
		$scope.$watch(function() {
			return $mdMedia('xs') || $mdMedia('sm');
		}, function(wantsFullScreen) {
			$scope.customFullscreen = (wantsFullScreen === true);
		});
	}

	vm.updateGraphs = function(){
		vm.getBar();
		vm.getPie();
	}

	vm.getBar = function(){
		$http({
			url: '/graph/bar',
			method: "GET",
			params: {
				start_date: vm.startDate, 
				end_date: vm.endDate
			}
		})
		.success(function(data){
			console.log('daily expense stat retrival successful');
			vm.barData = [{
				key: "expense",
				values: data.map(function(data){
					return {
						key: "expense",
						series: 0,
						size: -data[1],
						x: data[0],
						y: -data[1],
						y0: data[0],
						y1: -data[1]
					}
				})
			}];
		}).error(function(){
			console.log('daily expense stat retrival unsuccessful');
		});
	}

	vm.getPie = function(){
		$http({
			url: '/graph/pie',
			method: "GET",
			params: {
				start_date: vm.startDate, 
				end_date: vm.endDate
			}
		})
		.success(function(data){
			console.log('category expense stat retrival successful');
			vm.pieData = [];
			for(var category in data){
				vm.pieData.push({
					key: category,
					y: -Number(data[category])
				});
			}
		}).error(function(){
			console.log('category expense stat retrival unsuccessful');
		});
	}


	// retrieve initial data
	vm.updateGraphs();

});