sendFile = (file, toSummernote) ->
  data = new FormData
  data.append 'image[image]', file
  $.ajax
    data: data
    type: 'POST'
    url: '/images'
    cache: false
    contentType: false
    processData: false
    success: (data) ->
      img = document.createElement('IMG')
      img.src = data.url
      console.log data
      img.setAttribute('id', "sn-image-#{data.upload_id}")
      toSummernote.summernote 'insertNode', img

deleteFile = (file_id) ->
  $.ajax
    type: 'DELETE'
    url: "/images/#{file_id}"
    cache: false
    contentType: false
    processData: false

$(document).on 'turbolinks:load', ->
  $('[data-provider="summernote"]').each ->
    $(this).summernote
      lang: 'ja-JP'
      height: 400
      callbacks:
        onImageUpload: (files) ->
          sendFile files[0], $(this)
        onMediaDelete: (target, editor, editable) ->
          image_id = target[0].id.split('-').slice(-1)[0]
          console.log image_id
          if !!upload_id
            deleteFile image_id
          target.remove()