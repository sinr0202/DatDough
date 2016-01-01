
window.App = angular.module('DatDoughApp', 
	['ngMaterial',
	 //'mdDataTable',
	 'Devise',
	 'rails',
	 'ngFileUpload'])
	.config(function(AuthProvider, AuthInterceptProvider) {
			// Configure Auth service with AuthProvider
			// blank to use default
	});

$(document).on('ready page:load', function(){
	angular.bootstrap(document.body, ["DatDoughApp"]);
});