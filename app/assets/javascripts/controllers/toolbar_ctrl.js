'use strict'

/*
 * THE TOOLBAR CONTROLLER
 * ------------------------------------
 * Controls the ToolBar
 */


App.controller('ToolbarController', ['Auth', '$scope',
	function(Auth, $scope){

	var vm = this;
	var templates = [{name: 'welcome', url: 'welcome', signin: false},
                    {name: 'signIn', url: 'signin', signin: false},
                    {name: 'signUp', url: 'signup', signin: false},
                    {name: 'dashboard', url: 'dashboard', signin: true},
                    {name: 'table', url: 'table', signin: true},
                    {name: 'graph', url: 'graph', signin: true},
                    {name: 'setting', url: 'setting', signin: true},
                    {name: 'import', url: 'import', signin: true}];
    vm.template = templates[0].url;
    vm.isSignedIn = false

    Auth.currentUser()
    .then(function(user){
        vm.isSignedIn = Auth.isAuthenticated();
    }, function(error) {
        console.log('not authenticated yet')
    });

    vm.selectView = function(index){
        if (vm.isSignedIn != templates[index].signin){
            if(vm.isSignedIn){
                index = 3
            } else {
                index = 0
            }
        }
        vm.template = templates[index].url;
    };

    vm.signOut = function(){
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
    }

    $scope.$on('devise:login', function(event, args){
        console.log('signed in, showing dashboard')
        vm.isSignedIn = true
        vm.selectView(3)
    })

    $scope.$on('devise:new-registration', function(event, args){
        console.log('signed up, showing dashboard')
        vm.isSignedIn = true
        vm.selectView(3)
    })

    $scope.$on('devise:logout', function(event, args){
        console.log('signed out, showing welcome')
        vm.isSignedIn = false
        vm.selectView(0)
    })



}]);
