'use strict'

/*
 * THE SIGNUP CONTROLLER
 * ------------------------------------
 * Controls the Sign up page
 */

App.controller('SignUpController', ['Auth',
	function(Auth){

	var vm = this;
	vm.errors = '';
	vm.email = '';
	vm.password = '';
	vm.confirm = '';

	vm.signUp = function(){
		var credentials = {
	        email: vm.email,
	        password: vm.password,
	        password_confirmation: vm.confirm
	    };
	    var config = {
	        headers: {
	            'X-HTTP-Method-Override': 'POST'
	        }
	    };
	    Auth.register(credentials, config)
	    .then(function(registeredUser) {
	        console.log('sign up successful')
	    }, function(error) {
	    	alert('sign up unsuccessful')
	    	vm.errors = error.data.errors
	    	console.log(error)
	    });
	}

}]);