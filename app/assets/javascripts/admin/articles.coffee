jQuery ->
  $('#article_title')
    .on 'input propertychange', (evt) ->
      $('.appmsg_title > a').html($(this).val());
