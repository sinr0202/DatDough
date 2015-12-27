'use strict';

/*
 * THE FULL HEIGHT DIRECTIVE
 * ------------------------------------
 *
 *
 */

App.directive('fullheight', ['$window', function($window) {

    return {
        restrict: 'A',
        link: function ( scope, elem ) {

            //subtracting height of toolbar: 64
            var height = $window.innerHeight - 65;
            elem.css('height', height + 'px');
            angular.element($window).on('resize', function () {
                height = $window.innerHeight - 65;
                elem.css('height', height + 'px');
            });

        }
    };

}]);