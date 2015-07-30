window.App = angular.module("ExpenseTracker", ["ngRoute", "ngResource", 'rails', 'ng-rails-csrf', 'Devise', 'ui.bootstrap'])

App.config ["railsSerializerProvider", (railsSerializerProvider) ->
  railsSerializerProvider.underscore(angular.identity).camelize(angular.identity)
]

App.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5Mode({
    enabled: true
    requireBase: false
  })
]

window.version = '3.0.6'

$(document).on 'ready page:load' , ->
  angular.bootstrap(document.body, ['ExpenseTracker'])