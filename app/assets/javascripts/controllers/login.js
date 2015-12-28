'use strict'

/*
 * THE LOGIN CONTROLLER
 * ------------------------------------
 * Controls the Authorization
 */

App.controller('LoginController', ['Auth', 'Authorization', 
	function(Auth, Authorization){

	var vm = this;

	vm.signIn = function(email, password){
		Authorization.signIn(email, password)
	}

}]);

