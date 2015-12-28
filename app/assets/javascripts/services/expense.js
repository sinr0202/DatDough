App.factory('Expense', ['railsResourceFactory', function(railsResourceFactory){
	return railsResourceFactory({
		url: '/expenses',
		name: 'expense'
	});
}]);