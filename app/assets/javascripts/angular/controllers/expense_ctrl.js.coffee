App.controller 'ExpenseCtrl', [ '$scope', '$http', 'Expense', ($scope, $http, Expense) ->

  $scope.page = 0
  $scope.expenses = []
  $scope.editing = false

  $scope.load = ->
    $scope.page += 1
    Expense.query({page: $scope.page}).then (expenses) ->
      # CONCAT MIGHT BE TROUBLESOME. THINK OF CHANING IN THE FUTURE
      $scope.expenses = $scope.expenses.concat(expenses)
      console.log $scope.expenses
    return
  
  $scope.new = ->
    $scope.editing = false
    $scope.expense = {
      # default settings
      date: new Date()
      category: 'groceries'
      payment_method: 'cash'
    }
    return

  $scope.edit = (expense)->
    $scope.editing = $scope.expenses.indexOf(expense)
    Expense.get(expense).then (data)->
      data.date = new Date(data.date)
      data.amount = parseFloat(data.amount)
      $scope.expense = data
    return

  $scope.save = ->
    unless $scope.editing == false
      console.log 'update'
      new Expense($scope.expense).update().then (data)->
        $scope.expenses[$scope.editing] = data
        $scope.editing = false
    else
      console.log 'create'
      console.log $scope.expenses.length
      new Expense($scope.expense).create().then (data)->
        console.log data
        console.log $scope.expenses.length
        $scope.expenses.push(data)
        console.log $scope.expenses.length
        console.log $scope.expenses
    return

  $scope.delete = (expense)->
    console.log 'delete'
    return


  $scope.status = ->
    if $scope.editing == false
      return 'Add Transaction'
    else
      return 'Update Changes'

  $scope.load()

]
