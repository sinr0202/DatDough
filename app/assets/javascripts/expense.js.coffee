$(document).on('ready page:load', ->

  $('[data-toggle="popover"]').popover()
  $('body').on('click', (e) =>
    $('[data-toggle="popover"]').each =>
      if (!$(this).is(e.target) && $(this).has(e.target).length == 0 && $('.popover').has(e.target).length == 0)
        $(this).popover('hide');
  )

  daily = net = 0
  
  QueryString = ->
    query_string = "?";
    query = window.location.search.substring(1);
    vars = query.split("&");
    for v in vars
      pair = v.split("=");
      if pair[0] in ["start_date", "end_date"]
        query_string = query_string + pair[0] + "=" + pair[1] + "&"
    return query_string
  
  nv.addGraph( ->
    query = QueryString()
    $.ajax({
      url: '/expenses/daily' + query,
      dataType: 'json',
      async: false,
      success: (data) ->
        daily = data
        return
    })

    $.ajax({
      url: '/expenses/net' + query,
      dataType: 'json',
      async: false,
      success: (data) ->
        net = data
        return
    })

    graph_arr = [
      {
        "key" : "Daily",
        "bar": true,
        "values" : daily
      },
      {
        "key" : "Net",
        "values" : net
      }
    ]

    chart = nv.models.linePlusBarChart()
      .margin({top: 30, right: 60, bottom: 50, left: 70})
      .x((d,i) -> i )
      .y((d) -> d[1] )
      .color(d3.scale.category10().range())

    chart.xAxis
      .showMaxMin(false)
      .tickFormat((d) ->
        dx = graph_arr[0].values[d] && graph_arr[0].values[d][0] || 0
        d3.time.format('%x')(new Date(dx*1000))
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
      .transition().duration(500)
      .call(chart)

    nv.utils.windowResize(chart.update)

    chart
  )
)