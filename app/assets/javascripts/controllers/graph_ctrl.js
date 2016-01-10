'use strict'

/*
 * THE GRAPH CONTROLLER
 * ------------------------------------
 * Controls the Graph
 */

App.controller('GraphController', ['$http', 
	function($http){

	var vm = this;
	vm.expense = {}

	$http.get('/graph/bar')
	.success(function(data){
		console.log('daily expense stat retrival successful');
		vm.barData = [{
			key: "stream0",
			values: data.map(function(data){
				return {
					key: "Stream0",
					series: 0,
					size: -data[1],
					x: data[0],
					y: -data[1],
					y0: data[0],
					y1: -data[1]
				}
			})
		}];
		vm.barOptions = {
			chart: {
                type: 'multiBarChart',
                height: 450,
                margin : {
                    top: 20,
                    right: 20,
                    bottom: 45,
                    left: 45
                },
                clipEdge: true,
                //staggerLabels: true,
                duration: 500,
                stacked: true,
                xAxis: {
                    axisLabel: 'Date',
                    showMaxMin: false,
                    tickFormat: function(d){
                        return d3.time.format('%x')(new Date(d));
                    }
                },
                yAxis: {
                    axisLabel: 'Dollars Spent',
                    axisLabelDistance: -20,
                    tickFormat: function(d){
                        return d3.format(',.1f')(d);
                    }
                }
            }
		};
	}).error(function(){
		console.log('daily expense stat retrival unsuccessful');
	});
}])