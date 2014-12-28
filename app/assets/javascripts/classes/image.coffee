class window.Image
  constructor: ($image) ->
    @image = $image
    @src = $image.attr("src")
    
  resize: ->
    @rez = @rez || parseFloat(@image.attr("data-resize"))
    
  dimension: (name) ->
    dimension = @src.match(///\&#{name}\=(.*?)(\&|$)///)[1]
    self = @
    increment: ->
      parseInt(dimension * self.resize())
    
  filepicker_url: ->
    url = @src.match(/\/file\/(.*?)\//)[1]
    "https://www.filepicker.io/api/file/#{url}/convert?fit=crop&format=jpg&quality=60&h=#{@dimension("h").increment()}&w=#{@dimension("w").increment()}&cache=true"
      
  upscale: ->
    self = @
    img = $("<img/>").attr("src", @filepicker_url()).load( ->
      self.image.replaceWith(img)
    )

    
  