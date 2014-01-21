((window) ->
  Level = (stage) ->
    @initialize()
    @stage = stage

  initLayers = ->
    
    w = mapData.tilesets[0].tilewidth
    h = mapData.tilesets[0].tileheight
    imageData =
      images: [tileset]
      frames:
        width: w
        height: h

    # create spritesheet
    tilesetSheet = new createjs.SpriteSheet(imageData)
    
    # loading each layer at a time
    idx = 0

    while idx < mapData.layers.length
      layerData = mapData.layers[idx]
      initLayer layerData, tilesetSheet, mapData.tilewidth, mapData.tileheight  if layerData.type is "tilelayer"
      idx++
  
  # layer initialization
  initLayer = (layerData, tilesetSheet, tilewidth, tileheight) ->
    y = 0

    while y < layerData.height
      x = 0

      while x < layerData.width
        
        # create a new Sprite for each cell
        cellSprite = new createjs.Sprite(tilesetSheet)
        
        idx = x + y * layerData.width
        
        cellSprite.gotoAndStop layerData.data[idx] - 1
        
        cellSprite.x = x * tilewidth
        cellSprite.y = y * tileheight
        
        @stage.addChild cellSprite
        x++
      y++
  
  # utility function for loading assets from server
  httpGet = (theUrl) ->
    xmlHttp = null
    xmlHttp = new XMLHttpRequest()
    xmlHttp.open "GET", theUrl, false
    xmlHttp.send null
    xmlHttp.responseText
  
  # utility function for loading json data from server
  httpGetData = (theUrl) ->
    responseText = httpGet(theUrl)
    JSON.parse responseText

  p = Level:: = new createjs.Container()
  p.stage
  tileset = undefined
  mapData = undefined

  p.Container_initialize = p.initialize

  p.initialize = (sprite) ->
    @Container_initialize()
    $.ajax
      url: "images/Level1.json"
      async: false
      dataType: "json"
      success: (response) ->
        mapData = response
        tileset = new Image()
        tileset.src = mapData.tilesets[0].image
        tileset.onLoad = initLayers()

  window.Level = Level
) window