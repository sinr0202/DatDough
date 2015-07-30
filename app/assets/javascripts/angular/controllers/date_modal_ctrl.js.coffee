App.controller 'DateModalCtrl', ['$scope', '$modalInstance', 'startDate', 'endDate', 'ranged',
($scope, $modalInstance, startDate, endDate, ranged) ->

  $scope.startDate = startDate
  $scope.endDate = endDate
  $scope.ranged = ranged

  $scope.close = ->
    if $scope.dateForm.$invalid
      alert('Invalid Dates!')
      $modalInstance.close(false)
      return
    $scope.ranged($scope.startDate, $scope.endDate)
    $modalInstance.close(true)
]