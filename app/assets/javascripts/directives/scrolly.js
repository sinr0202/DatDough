App.directive('scrolly', function () {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            var raw = element[0];
            console.log('loading directive');
                
            element.bind('scroll', function () {
                var buffer = 100;
                if (raw.scrollTop + raw.offsetHeight > raw.scrollHeight - buffer) {
                    scope.$apply(attrs.scrolly);
                }
            });
        }
    };
});