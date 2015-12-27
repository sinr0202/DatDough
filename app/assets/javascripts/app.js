window.App = angular.module('DatDoughApp', ['ngMaterial']);

$(document).on('ready page:load', function(){

	angular.bootstrap(document.body, ["DatDoughApp"]);

});