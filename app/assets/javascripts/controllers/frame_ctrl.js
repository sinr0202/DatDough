'use strict'

/*
 * THE FRAME CONTROLLER
 * ------------------------------------
 * Controls the Frame
 */


App.controller('FrameController', ['Auth', '$scope',
	function(Auth, $scope){

	var vm = this;
	var templates = [{name: 'welcome', url: 'welcome', signin: false},
                    {name: 'signIn', url: 'signin', signin: false},
                    {name: 'signUp', url: 'signup', signin: false},
                    {name: 'dashboard', url: 'dashboard', signin: true},
                    {name: 'table', url: 'table', signin: true},
                    {name: 'graph', url: 'graph', signin: true},
                    {name: 'settings', url: 'settings', signin: true},
                    {name: 'import', url: 'import', signin: true}];
                    
    vm.template = templates[0].url;
    vm.isSignedIn = false;

    Auth.currentUser()
    .then(function(user){
        vm.isSignedIn = Auth.isAuthenticated();
    }, function(error) {
        console.log('not authenticated yet');
    });

    vm.selectView = function(index){
        if (vm.isSignedIn != templates[index].signin){
            if(vm.isSignedIn){
                index = 3;
            } else {
                index = 0;
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
            alert("you're signed out now.");
        }, function(error) {
            alert("an error has occurred when signing out")
            console.log(error);
        });
    }

    vm.scroll = function(){
        $scope.$broadcast('scrolling');
    }

    $scope.$on('devise:login', function(event, args){
        vm.isSignedIn = true;
        vm.selectView(3);
    });

    $scope.$on('devise:new-registration', function(event, args){
        vm.isSignedIn = true;
        vm.selectView(3);
    });

    $scope.$on('devise:logout', function(event, args){
        vm.isSignedIn = false;
        vm.selectView(0);
    });



}]);
