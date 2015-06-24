jQuery ->
  handler = ->
    more_posts_url = $('.pagination .next_page a').attr('href')
    if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
      $('.pagination').hide()
      $('#ajax-loading').show()
      $(window).unbind 'scroll', handler
      $.getScript more_posts_url, ->
        $(window).bind 'scroll', handler
    
  if $('#infinite-scrolling').size() > 0
    $(window).bind 'scroll', handler
      
    
        
