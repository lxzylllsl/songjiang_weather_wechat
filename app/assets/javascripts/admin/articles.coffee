jQuery ->
  editor = CKEDITOR.replace('article_content', { height: '512px'})
  
  $('#article_title')
    .on 'input propertychange', (evt) ->
      $('.appmsg_title > a').html($(this).val());
