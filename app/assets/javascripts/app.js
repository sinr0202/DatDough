
window.App = angular.module('DatDoughApp', ['ngMaterial', 'Devise']).
	config(function(AuthProvider, AuthInterceptProvider) {
		// Configure Auth service with AuthProvider
	});

$(document).on('ready page:load', function(){
	angular.bootstrap(document.body, ["DatDoughApp"]);
});