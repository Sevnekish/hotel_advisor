$ ->
  $('.hotel-image').each ->
    originalImageSrc = $(this).attr('src').replace('preview_', '')
    $(this).magnificPopup
      items:
        src: originalImageSrc
      type: 'image'
      closeOnContentClick: true
      mainClass: 'mfp-img-mobile'
      image:
        verticalFit: true