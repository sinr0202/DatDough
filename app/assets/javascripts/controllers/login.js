'use strict'

/*
 * THE LOGIN CONTROLLER
 * ------------------------------------
 * Controls the Authorization
 */

App.controller('LoginController', function(Auth){


	var vm = this;
	vm.errorMsg = '';
	vm.username = '';
	vm.password = '';
	vm.user = {}

	console.log('checking for authentcation...')
	Auth.currentUser().then(function(user) {
		console.log('user authenticated: ', Auth.isAuthenticated());
        console.log(user);
    }, function(error) {
		console.log('user authenticated: ', Auth.isAuthenticated());
        console.log(error)
    });

	vm.signIn = function(email, password){
		var credentials = {
            email: email,
            password: password
        };
        var config = {
            headers: {
                'X-HTTP-Method-Override': 'POST'
            }
        };

		if (Auth.isAuthenticated()){
			vm.user = Auth._currentUser
		} else {
			vm.user = {}
			Auth.login(credentials, config).then(function(user) {
				console.log('signin successful')
				vm.user = Auth._currentUser
			}, function(error) {
			    console.log('signin failed')
			    console.log(error)
			});
		}
	}

	vm.signOut = function(){
		var config = {
			headers: {
				'X-HTTP-Method-Override': 'DELETE'
			}
		};
		Auth.logout(config).then(function(oldUser) {
			alert("you're signed out now.");
		}, function(error) {
			console.log('signout failed')
			console.log(error)
		});
	}

});

