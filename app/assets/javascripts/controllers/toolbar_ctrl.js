'use strict'

/*
 * THE TOOLBAR CONTROLLER
 * ------------------------------------
 * Controls the ToolBar
 */


App.controller('ToolbarController', ['Authorization',
	function(Authorization){

	var vm = this;

	vm.isLoggedIn = Authorization.isSignedIn();


	//view controller
	var templates = [{name: 'welcome', url: 'welcome'},
                     {name: 'signIn', url: 'signin'},
                     {name: 'signUp', url: 'signup'},
                     {name: 'dashboard', url: 'dashboard'}];

    //On load
    vm.template = templates[0].url;

    // //Change on view click
   	vm.selectView = function(index){
        vm.template = templates[index].url;
    };


}]);
