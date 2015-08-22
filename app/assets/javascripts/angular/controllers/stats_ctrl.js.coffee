App.controller 'StatsCtrl', ['$scope', '$http','$modal', ($scope, $http, $modal) ->

  $scope.maxIncomeCategory = 3
  $scope.maxExpenseCategory = 6
  $scope.endDate = new Date()
  $scope.startDate = new Date()
  $scope.startDate.setDate($scope.startDate.getDate()-60)
  $scope.incomePieSettingOpen = false
  $scope.expensePieSettingOpen = false

  $scope.queryString = ->
    query = ''
    if $scope.startDate
      query += '?start_date='+$scope.startDate.getFullYear()+'-'+($scope.startDate.getMonth()+1)+'-'+$scope.startDate.getDate()
    if $scope.endDate
      query += '&end_date='+$scope.endDate.getFullYear()+'-'+($scope.endDate.getMonth()+1)+'-'+$scope.endDate.getDate()
    return query

  $scope.maxIncomeUp = ->
    $scope.maxIncomeCategory++
    $scope.otherIncomeCategoryCreator()

  $scope.maxIncomeDown = ->
    $scope.maxIncomeCategory--
    $scope.otherIncomeCategoryCreator()

  $scope.maxExpenseUp = ->
    $scope.maxExpenseCategory++
    $scope.otherExpenseCategoryCreator()

  $scope.maxExpenseDown = ->
    $scope.maxExpenseCategory--
    $scope.otherExpenseCategoryCreator()
    
  $scope.updatePieGraph = ->
    if ($scope.startDate && $scope.endDate) && ($scope.startDate < $scope.endDate)
      $scope.getCategoryExpense()
    else

  $scope.getAverageStats = ->
    $http.get('/stats/monthly'+$scope.queryString()).
      success((data, status, headers, config) ->
        $scope.stats = data
        console.log data
      )

  $scope.getCategoryExpense = ->
    $http.get('/stats/category' + $scope.queryString()).
      success((data, status, headers, config) ->
        $scope.incomeCategoryData = data.income
        $scope.otherIncomeCategoryCreator()
        $scope.expenseCategoryData = data.expense
        $scope.otherExpenseCategoryCreator()
      ).
      error((data, status, headers, config) ->
      )

  $scope.otherIncomeCategoryCreator = ->
    resultArray = []
    otherTotal = 0
    # above
    $scope.maxIncomeCategory = Object.keys($scope.incomeCategoryData).length-1 if Object.keys($scope.incomeCategoryData).length <= $scope.maxIncomeCategory
    # below
    $scope.maxIncomeCategory = 1 if $scope.maxIncomeCategory < 1
    max = $scope.maxIncomeCategory
    max++ if Object.keys($scope.incomeCategoryData).length - 1 == $scope.maxIncomeCategory
    # $scope.maxIncomeCategory = Object.keys($scope.incomeCategoryData).length + 1 if Object.keys($scope.incomeCategoryData).length + 1 == $scope.maxIncomeCategory
    for category, total of $scope.incomeCategoryData
      for i in [max-1..0]
        continue unless resultArray[i] && total < resultArray[i].y
        break
      if i + 1 == max
        otherTotal += parseFloat(total)
      else
        resultArray.splice(i+1, 0, {'key':category,'y':total})
        otherTotal += parseFloat(resultArray.pop().y) if resultArray.length > max
    resultArray[max] = {'key':'other','y':otherTotal}
    $scope.incomePieData = resultArray
    $scope.incomePieGraph()

  $scope.otherExpenseCategoryCreator = ->
    resultArray = []
    otherTotal = 0
    # above
    $scope.maxExpenseCategory = Object.keys($scope.expenseCategoryData).length-1 if Object.keys($scope.expenseCategoryData).length <= $scope.maxExpenseCategory
    # below
    $scope.maxExpenseCategory = 1 if $scope.maxExpenseCategory < 1
    max = $scope.maxExpenseCategory
    max++ if Object.keys($scope.expenseCategoryData).length - 1 == $scope.maxExpenseCategory
    for category, total of $scope.expenseCategoryData
      for i in [max-1..0]
        continue unless resultArray[i] && total < resultArray[i].y
        break
      if i + 1 == max
        otherTotal += parseFloat(total)
      else
        resultArray.splice(i+1, 0, {'key':category,'y':total})
        otherTotal += parseFloat(resultArray.pop().y) if resultArray.length > max
    resultArray[max] = {'key':'other','y':otherTotal}
    $scope.expensePieData = resultArray
    $scope.expensePieGraph()

  $scope.incomePieGraph = ->
    nv.addGraph( ->
      $scope.chart = nv.models.pieChart()
        .x((d)-> return d.key )
        .y((d)-> return d.y )
        .width(400)
        .height(400)
        .labelsOutside(true)
        .showLegend(false)
      d3.select("#income-pie-chart svg")
        .datum($scope.incomePieData)
        .transition().duration(1200)
        .call($scope.chart)
      return $scope.chart
    )

  $scope.expensePieGraph = ->
    nv.addGraph( ->
      $scope.chart = nv.models.pieChart()
        .x((d)-> return d.key )
        .y((d)-> return d.y )
        .width(400)
        .height(400)
        .labelsOutside(true)
        .showLegend(false)
      d3.select("#expense-pie-chart svg")
        .datum($scope.expensePieData)
        .transition().duration(1200)
        .call($scope.chart)
      return $scope.chart
    )

  $scope.ranged = (startDate, endDate) ->
    $scope.startDate = startDate
    $scope.endDate = endDate

  $scope.openDateModal = (size) ->
    dateModal = $modal.open({
      animation:true
      templateUrl: 'dateModal.html'
      controller: 'DateModalCtrl'
      size:size
      resolve:{
        startDate: () ->
          return $scope.startDate
        endDate: () ->
          return $scope.endDate
        ranged: () ->
          return $scope.ranged    
      }
    })
    dateModal.result.then (refresh) ->
      $scope.updatePieGraph() if refresh


  $scope.initialize = ->
    $scope.endDate = new Date()
    $scope.startDate = new Date()
    $scope.startDate.setDate($scope.startDate.getDate()-60)
    $scope.getAverageStats()
    $scope.getCategoryExpense()
  $scope.$on('showGraph', $scope.initialize)
]