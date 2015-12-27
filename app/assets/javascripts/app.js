window.App = angular.module('DatDoughApp', []);

$(document).on('ready page:load', function(){

	angular.bootstrap(document.body, ["DatDoughApp"]);

});