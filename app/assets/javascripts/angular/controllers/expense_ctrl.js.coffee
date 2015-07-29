App.controller 'ExpenseCtrl', [ '$scope', '$http', '$modal', 'Expense', ($scope, $http, $modal, Expense) ->

  $scope.page = 0
  $scope.alreadyLoading = false
  $scope.expenses = []
  $scope.editing = false
  $scope.dailyExpense = false
  $scope.netExpense = false
  $scope.endDate = new Date()
  $scope.startDate = new Date()
  $scope.startDate.setDate($scope.startDate.getDate()-60)

  $scope.loadNextExpense = ->
    return if $scope.alreadyLoading
    $scope.showLoading()
    $scope.alreadyLoading = true
    $scope.page += 1
    Expense.query({page: $scope.page}).then (expenses) ->
      $scope.hideLoading()
      # if expenses are empty dont let it load again
      return if expenses.length < 30
      $scope.alreadyLoading = false
      $scope.expenses = $scope.expenses.concat(expenses)
    return

  $scope.queryString = ->
    query = ''
    if $scope.startDate
      query += '?start_date='+$scope.startDate.getFullYear()+'-'+($scope.startDate.getMonth()+1)+'-'+$scope.startDate.getDate()
    if $scope.endDate
      query += '&end_date='+$scope.endDate.getFullYear()+'-'+($scope.endDate.getMonth()+1)+'-'+$scope.endDate.getDate()
    return query

  $scope.getDailyExpense = ->
    # for AND condition for net
    $scope.dailyExpense = false
    $http.get('/expenses/daily' + $scope.queryString()).
      success((data, status, headers, config)->
        $scope.dailyExpense = data
        $scope.graph()
      ).
      error((data, status, headers, config) ->
        console.log 'fail' 
        console.log data 
      )

  $scope.getNetExpense = ->
    # for AND condition for daily
    $scope.netExpense = false
    $http.get('/expenses/net' + $scope.queryString()).
      success((data, status, headers, config)->
        $scope.netExpense = data
        $scope.graph()
      ).
      error((data, status, headers, config) ->
        console.log 'fail' 
        console.log data 
      )

  $scope.updateGraph = ->
    if ($scope.startDate && $scope.endDate) && ($scope.startDate < $scope.endDate)
      $scope.getDailyExpense()
      $scope.getNetExpense()
    else
      console.log 'invalid date'

  $scope.graph = ->
    return unless ($scope.dailyExpense and $scope.netExpense)
    nv.addGraph( ->
      graph_arr = [{
          "key" : "Daily",
          "bar": true,
          "values" : $scope.dailyExpense
        },{
          "key" : "Net",
          "values" : $scope.netExpense
        }]
      chart = nv.models.linePlusBarChart()
        .margin({top: 30, right: 60, bottom: 50, left: 70})
        .x((d,i) -> i )
        .y((d) -> d[1] )
        .color(d3.scale.category10().range())
      chart.xAxis
        .showMaxMin(false)
        .tickFormat((d) ->
          dx = graph_arr[0].values[d] && graph_arr[0].values[d][0] || 0
          d3.time.format('%x')(new Date(dx))
        )
      chart.y1Axis
        .tickFormat((d) ->
          '$' + d3.format(',f')(d) )
      chart.y2Axis
        .tickFormat((d) ->
          '$' + d3.format(',f')(d) )
      chart.bars.forceY([0])
      d3.select('#chart svg')
        .datum(graph_arr)
        .transition()
        .call(chart)
      nv.utils.windowResize(chart.update)
      return chart
    )
  
  $scope.new = ->
    $scope.editing = false
    $scope.expense = {
      # default settings
      date: new Date()
      category: 'dining'
      payment_method: 'cash'
    }
    $scope.openTransactionModal()
    return

  $scope.edit = (expense)->
    $scope.editing = $scope.expenses.indexOf(expense)
    Expense.get(expense).then (data)->
      console.log data.date
      data.date = new Date(data.date + 'EDT')
      console.log data.date
      data.amount = parseFloat(data.amount)
      $scope.expense = data
      $scope.openTransactionModal()
    return

  $scope.saved = (expense) ->
    $scope.expenses.push(expense)

  $scope.updated = (expense)->
    $scope.expenses[$scope.editing] = expense

  $scope.deleted = ->
    $scope.expenses.splice($scope.editing,1)

  $scope.ranged = (startDate, endDate) ->
    $scope.startDate = startDate
    $scope.endDate = endDate

  $scope.scroll = ->
    more_posts_url = $('.pagination .next_page a').attr('href')
    if $(window).scrollTop() > $(document).height() - $(window).height() - 60
      $scope.loadNextExpense()

  $scope.showLoading = ->
    $('#ajax-loading').show()

  $scope.hideLoading = ->
    $('#ajax-loading').hide()

  $scope.openTransactionModal = (size) -> 
    transactionModal = $modal.open({
      animation: true
      templateUrl: 'transactionModal.html'
      controller: 'TransactionModalCtrl'
      size: size
      resolve: {
        expense: () ->
          return $scope.expense
        editing: () ->
          return $scope.editing
        saved: () ->
          return $scope.saved
        updated: () ->
          return $scope.updated
        deleted: () ->
          return $scope.deleted
      }
    })

    transactionModal.result.then (refresh) ->
      $scope.updateGraph() if refresh
      console.log 'modal closed succssfully'

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
      $scope.updateGraph() if refresh
      console.log 'modal closed succssfully'      

  $scope.loadNextExpense()
  $scope.updateGraph()
  $(window).bind 'scroll', $scope.scroll
]
