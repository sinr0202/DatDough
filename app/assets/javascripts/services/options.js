'use strict';

/**
 * THE Options SERVICE
 * ------------------------------------
 * Retrieves the Options from backend
 */

App.factory('Options', ['$http', '$q', 
        function($http, $q) {

        return {
            getCategory: function() {

                var deferred = $q.defer();

                $http.get('api/categories')
                .success(function(data) {
                    deferred.resolve(data);
                }).error(function() {
                    deferred.reject();
                });

                return deferred.promise;
            },
            getPaymentMethod: function() {

                var deferred = $q.defer();

                $http.get('api/paymethods')
                .success(function(data) {
                    deferred.resolve(data);
                }).error(function() {
                    deferred.reject();
                });

                return deferred.promise;
            }

        };
}]);