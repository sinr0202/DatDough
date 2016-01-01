'use strict'

/*
 * THE IMPORT CONTROLLER
 * ------------------------------------
 * Controls the Import
 */

App.controller('ImportController',
	function($scope, Upload){

	var vm = this;
	var url = '/import';
	vm.loading = false;
	vm.processed = false;
	vm.error = false;

	vm.submit = function(){
		if(confirm('Upload '+vm.csvFile.name+'?')){
			if(vm.csvFile){
				vm.upload(vm.csvFile)
			} else {
				alert('select a file first!');
			}
		}
		return;
	};

	vm.upload = function(file){
		vm.processed = true;
		vm.loading = true;
		vm.uploading = true;
		vm.error = false;
		Upload.upload({
            url: url,
            data: {file: file}
        }).then(function (resp) {
			vm.file = false;
			vm.loading = false;
			alert("csv file upload successful");
            console.log('Success ' + resp.config.data.file.name + 'uploaded. Response: ' + resp.data);
        }, function (resp) {
			vm.loading = false;
			vm.error = resp.data.error;
			console.log(vm.error);
			alert("csv file upload unsuccessful");
            console.log('Error status: ' + resp.status);
        }, function (evt) {
            var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
            if (progressPercentage == 100){
				vm.uploading = false;
            }
            console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
        });
        return;
	};



})	