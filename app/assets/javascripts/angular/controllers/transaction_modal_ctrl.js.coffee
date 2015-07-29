App.controller 'TransactionModalCtrl', ['$scope', '$modalInstance', 'Expense', 'expense', 'editing', 'saved', 'updated', 'deleted', 
($scope, $modalInstance, Expense, expense, editing, saved, updated, deleted) ->

  $scope.expense = expense
  $scope.editing = editing
  $scope.saved = saved
  $scope.updated = updated
  $scope.deleted = deleted

  $scope.save = ->
    if $scope.transactionForm.$invalid
      alert('Invalid submission! Try again')
      return
    return unless editing == false
    new Expense($scope.expense).create().then (data)->
      $scope.saved(data)
      $scope.close(true)
    , (error) ->
      console.log error

  $scope.update = ->
    if $scope.transactionForm.$invalid
      alert('Invalid submission! Try again')
      return
    return if editing == false
    new Expense($scope.expense).update().then (data)->
      $scope.updated(data)
      $scope.close(true)
    , (error) ->
      console.log error

    # $scope.deleteExpense($scope.expense)
  $scope.delete = ->
    if(confirm('Are you sure?'))
      $scope.expense.delete().then (data) ->
        $scope.deleted()
        $scope.close(true)
      , (error) ->
        console.log error

  $scope.close = (refresh) ->
    $modalInstance.close(refresh)

]