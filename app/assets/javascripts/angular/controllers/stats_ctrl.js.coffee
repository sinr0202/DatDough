App.controller 'StatsCtrl', ['$scope', '$http','$modal', ($scope, $http, $modal) ->

  $scope.queryString = ->
    query = ''
    if $scope.startDate
      query += '?start_date='+$scope.startDate.getFullYear()+'-'+($scope.startDate.getMonth()+1)+'-'+$scope.startDate.getDate()
    if $scope.endDate
      query += '&end_date='+$scope.endDate.getFullYear()+'-'+($scope.endDate.getMonth()+1)+'-'+$scope.endDate.getDate()
    return query

  $scope.getCategoryExpense = ->
    # for AND condition for net
    maxCategory = 8
    $http.get('/stats/category' + $scope.queryString()).
      success((data, status, headers, config)->
        resultArray = []
        otherTotal = 0
        maxCategory = Object.keys(data).length if Object.keys(data).length < maxCategory
        for category, total of data
          for i in [maxCategory-1..0]
            continue unless resultArray[i] && total < resultArray[i].y
            break
          if i + 1 == maxCategory
            otherTotal += parseFloat(total)
          else
            resultArray.splice(i+1, 0, {'key':category,'y':total})
            otherTotal += parseFloat(resultArray.pop().y) if resultArray.length > maxCategory
        resultArray[maxCategory] = {'key':'other','y':otherTotal}
        $scope.pieData = resultArray
        $scope.pieGraph()
      ).
      error((data, status, headers, config) ->
        console.log 'fail' 
        console.log data 
      )
  $scope.pieGraph = ->
    nv.addGraph( ->
      $scope.chart = nv.models.pieChart()
        .x((d)-> return d.key )
        .y((d)-> return d.y )
        .width(400)
        .height(400)
        .labelsOutside(true)
        .showLegend(false)
      d3.select("#pie-chart svg")
        .datum($scope.pieData)
        .transition().duration(1200)
        .call($scope.chart)
      return $scope.chart
    )

  $scope.initialize = ->
    console.log 'graph initialized'
    $scope.endDate = new Date()
    $scope.startDate = new Date()
    $scope.startDate.setDate($scope.startDate.getDate()-60)
    $scope.getCategoryExpense()

  $scope.$on('showGraph', $scope.initialize)
]