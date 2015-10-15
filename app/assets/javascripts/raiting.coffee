$ ->
  $('.review-rating, .average-rating').raty
    readOnly: true,
    score: ->
      $(this).attr('data-score')
    path: '/assets/'

  $('#rating-input').raty
    score: ->
      $(this).attr('data-score')
    path: '/assets/'
    scoreName: 'review[rating]'