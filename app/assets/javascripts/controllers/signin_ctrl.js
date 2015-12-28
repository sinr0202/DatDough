'use strict'

/*
 * THE LOGIN CONTROLLER
 * ------------------------------------
 * Controls the Authorization
 */

App.controller('SignInController', ['Authorization', 
	function(Authorization){

	var vm = this;
	vm.email = '';
	vm.password = '';

	vm.signIn = function(){
		Authorization.signIn(vm.email, vm.password);
		vm.password = '';
	}

}]);

