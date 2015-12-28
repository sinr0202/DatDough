App.factory('Authorization', function(Auth){
	return {
    	signIn : function(email, password){
			var credentials = {
			    email: email,
			    password: password
			};
			var config = {
			    headers: {'X-HTTP-Method-Override': 'POST'}
			};

		    Auth.login(credentials, config)
		    .then(function(){
		    	console.log('sign in successful');
		    },function(error){
		    	alert('sign in unsuccessful');
		    	console.log(error);
		    })
		    return Auth.isAuthenticated()
    	},
    	signOut : function(){
			var config = {
				headers: {
					'X-HTTP-Method-Override': 'DELETE'
				}
			};
			Auth.logout(config).then(function(oldUser) {
				console.log('sign out successful')
				alert("you're signed out now.");
			}, function(error) {
				console.log('sign out unsuccessful')
				console.log(error)
			});
			return !Auth.isAuthenticated()
    	},
    	signUp : function(){
    		return false	
    	}
    }
})