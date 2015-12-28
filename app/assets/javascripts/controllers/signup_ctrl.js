'use strict'

/*
 * THE SIGNUP CONTROLLER
 * ------------------------------------
 * Controls the Sign up page
 */


App.controller('SignUpController', ['Auth', '$scope',
	function(Auth, $scope){

	var vm = this;
	vm.errorMsg = '';
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
	    Auth.register(credentials, config).then(function(registeredUser) {
	        console.log('sign up successful')
	        $scope.$emit('signup')
	    }, function(error) {
	    	alert('sign up unsuccessful')
	    	vm.errorMsg = error.data.errors
	    	console.log(error)
	    });
	}

}]);