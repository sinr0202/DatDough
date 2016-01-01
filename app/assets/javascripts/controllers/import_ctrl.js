'use strict'

/*
 * THE IMPORT CONTROLLER
 * ------------------------------------
 * Controls the Import
 */

App.controller('ImportController',
	function($scope, Upload){

	var vm = this;
	var url = '/import'
	vm.loading = false;
	vm.processed = false;

	vm.submit = function(){
		console.log('submit clicked');
		if(vm.csvFile){
			vm.upload(vm.csvFile)
		} else {
			alert('select a file first!')
		}
	}

	vm.upload = function(file){
		vm.processed = true;
		vm.loading = true;
		vm.uploading = true;
		Upload.upload({
            url: url,
            data: {file: file}
        }).then(function (resp) {
        	delete vm.file;
			vm.loading = false;
            console.log('Success ' + resp.config.data.file.name + 'uploaded. Response: ' + resp.data);
        }, function (resp) {
			vm.loading = false;
            console.log('Error status: ' + resp.status);
        }, function (evt) {
            var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
            if (progressPercentage == 100){
				vm.uploading = false;
            }
            console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
        });
	};



})	