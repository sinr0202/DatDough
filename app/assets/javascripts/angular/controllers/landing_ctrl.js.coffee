App.controller 'LandingCtrl', ['$scope', '$http', ($scope, $http) ->

	$http.get('/user').then (response) ->
		if response.data.session
			$scope.$broadcast('signin')
			$scope.showExpense()
		else
			$scope.showLanding()

	$scope.demo = ->
		$scope.email = "test@example.com"
		$scope.password = "123123123"
		$scope.login()

	$scope.showLanding = ->
		$scope.selectTab(1)
		$scope.loggedIn = false
		$scope.background = true
		$scope.loginError = false
		$scope.signupError = false

	$scope.showExpense = ->
		$scope.selectTab(4)
		$scope.loggedIn = true
		$scope.background = false

	$scope.showGraph = ->
		$scope.$broadcast('showGraph')	
		$scope.selectTab(5)
		$scope.background = false

	$scope.tabSelected = (tab)->
		return $scope.currentTab == tab

	$scope.selectTab = (tab)->
		console.log($scope.background)
		$scope.loginError = false
		$scope.signupError = false
		$scope.currentTab = tab
		return

	$scope.login = ()->
		console.log('login')
		$scope.rememberMe = false
		data = {
			user: {
				email: $scope.email,
				password: $scope.password
				remember_me: $scope.rememberMe
			}
		}
		$http.post('/users/sign_in', data).then (response) ->
			console.log 'broadcast'
			$scope.$broadcast('signin')
			$scope.showExpense()
		,(response) ->
			$scope.signupError = true;

	$scope.signUp = ()->
		console.log('signup')
		data = {
			user: {
				email: $scope.email,
				password: $scope.password
				password_confirmation: $scope.passwordConfirm
			}
		}
		$http.post('/users', data).then (response) ->
			$scope.selectTab(2)
			$scope.login()
		,(response) ->
			$scope.signupError = true;

	$scope.logout = ()->
		console.log('logout')
		$http.delete('/users/sign_out')
		$scope.showLanding()
	
]