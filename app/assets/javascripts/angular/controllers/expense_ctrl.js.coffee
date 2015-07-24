App.controller 'ExpenseCtrl', [ '$scope', '$http', 'Expense', ($scope, $http, Expense) ->

  $scope.page = 0
  $scope.expenses = []
  $scope.editing = false
  $scope.dailyExpense = false
  $scope.netExpense = false
  $scope.endDate = new Date()
  $scope.startDate = new Date()
  $scope.startDate.setDate($scope.startDate.getDate()-60)

  $scope.loadNextExpense = ->
    $scope.page += 1
    Expense.query({page: $scope.page}).then (expenses) ->
      $scope.expenses = $scope.expenses.concat(expenses)
      $scope.hideLoading()
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

  $scope.updateExpense = ->
    console.log 'update'
    if ($scope.startDate && $scope.endDate) && ($scope.startDate < $scope.endDate)
      console.log $scope.queryString()
      $scope.getDailyExpense()
      $scope.getNetExpense()
    else
      console.log 'invalid date'

  $scope.graph = ->
    console.log 'graphzz'
    unless ($scope.dailyExpense and $scope.netExpense)
      return
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
      new Expense($scope.expense).create().then (data)->
        $scope.expenses.push(data)
    $scope.graph()
    return

  $scope.delete = (expense)->
    if(confirm('Are you sure?'))
      expense.delete().then (data) ->
        delete $scope.expenses[$scope.editing]
        $scope.editing = false
        $scope.graph()
    return


  $scope.status = ->
    if $scope.editing == false
      return 'Add Transaction'
    else
      return 'Update Changes'

  $scope.scroll = ->
    console.log 'scrollllllll'
    more_posts_url = $('.pagination .next_page a').attr('href')
    if $(window).scrollTop() > $(document).height() - $(window).height() - 60
      console.log 'nexttttt'
      $scope.loadNextExpense()
      $scope.showLoading()

  $scope.showLoading = ->
    $('#ajax-loading').show()

  $scope.hideLoading = ->
    $('#ajax-loading').hide()

  $scope.loadNextExpense()
  $scope.updateExpense()
  $(window).bind 'scroll', $scope.scroll
  $('[data-toggle="popover"]').popover()
]
