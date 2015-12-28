'use strict'

/*
 * THE TOOLBAR CONTROLLER
 * ------------------------------------
 * Controls the ToolBar
 */


App.controller('ToolbarController', ['Authorization', function(Authorization){

	var vm = this;

	vm.isLoggedIn = Authorization.isSignedIn();


}]);
