'use strict'

/*
 * THE LOGIN CONTROLLER
 * ------------------------------------
 * Controls the Authorization
 */

App.controller('SignInController', ['Auth',
	function(Auth){

	var vm = this;
	vm.email = '';
	vm.password = '';
	vm.remember = 1

	vm.signIn = function(){
		var credentials = {
			email: vm.email,
			password: vm.password,
			remember_me: vm.remember
		};
		var config = {
			headers: {'X-HTTP-Method-Override': 'POST'},
		};

		Auth.login(credentials, config)
		.then(function(){
			console.log('sign in successful');
		},function(error){
			alert('sign in unsuccessful');
			console.log(error);
		});
	}

}]);

