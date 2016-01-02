'use strict';

/*
 * THE SCROLL DIRECTIVE
 * ------------------------------------
 * Enables infinite scroll on the stream
 *
 */

App.directive('scroll', ['$window', function($window) {

    return {
        link: function(scope, elem) {

            var windowHeight = $window.innerHeight;
            var elemId = '#' + elem.context.id;
            var scrollLock, scrollTop, streamHeight;

            scope.$watch('scrollLock', function(){
                scrollLock = scope.scrollLock;
            });

            angular.element(elemId).parent().bind('scroll', function() {
                scrollTop = $(elemId).parent().scrollTop();
                streamHeight = $(elemId).innerHeight();

                if (scrollLock === false && streamHeight - windowHeight - scrollTop < 600) {
                    scrollLock = true;
                    scope.nextPortfolios();
                }

            });
        }
    };

}]);