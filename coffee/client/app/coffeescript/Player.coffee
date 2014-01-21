((window) ->
  Player = (sprite, stage) ->
    @initialize sprite, stage

  p = Player:: = new createjs.Container()
  
  # public properties:
  p.vX
  p.vY
  p.bounds
  p.hit
  p.lastKey
  MAX_VELOCITY = 20
  stage
  
  # constructor:
  p.Container_initialize = p.initialize #unique to avoid overiding base class

  p.initialize = (sprite, stage) ->
    @Container_initialize()
    @playerBody = sprite
    stage = stage
    @addChild @playerBody
    
    @vX = 0
    @vY = 0

  # public methods:
  p.tick = (event, level) ->
    view = this
    hit = false
    right_side = view.x + view.width/2
    left_side = view.x - view.width/2
    top_side = view.y + view.height/2
    bottom_side = view.y - view.height/2
    stage.children.forEach (child) ->
      if child.type is "tile"
        if child.hit is "true"
          if right_side > child.x and right_side < child.x+96 and view.y > child.y and view.y < child.y+96
            hit = true
            view.x -= 5
          if left_side < child.x+96 and left_side > child.x and view.y > child.y and view.y < child.y+96
            hit = true
            view.x += 5
          if view.x > child.x and view.x < child.x+96 and top_side < child.y+96 and top_side > child.y
            hit = true
            view.y += 5
          if view.x > child.x and view.x < child.x+96 and bottom_side < child.y and bottom_side < child.y+96
            hit = true
            view.y -= 5
    #move by velocity
    if hit isnt true
      @x += @vX
      @y += @vY

  p.accelerate = (keys) ->
    view = this
    view.vX = 0
    view.vY = 0
    latestKey = false
    
    keys.forEach (key) ->
      view.vX += -MAX_VELOCITY  if key is "left"
      view.vX += MAX_VELOCITY  if key is "right"
      view.vY += -MAX_VELOCITY  if key is "up"
      view.vY += MAX_VELOCITY  if key is "down"
      latestKey = key

    if latestKey isnt false
      @playerBody.gotoAndPlay "run"  if @playerBody.currentAnimation isnt "run"
    else
      @playerBody.gotoAndPlay "idle"
    switch latestKey
      when "left"
        if @playerBody.currentAnimation isnt "left"
          @playerBody.gotoAndPlay "left"
          @lastKey = "left"
      when "right"
        if @playerBody.currentAnimation isnt "right"
          @playerBody.gotoAndPlay "right"
          @lastKey = "right"
      when "up"
        if @playerBody.currentAnimation isnt "up"
          @playerBody.gotoAndPlay "up"
          @lastKey = "up"
      when "down"
        if @playerBody.currentAnimation isnt "down"
          @playerBody.gotoAndPlay "down"
          @lastKey = "down"
      else
        switch @lastKey
          when "left"
            @playerBody.gotoAndPlay "left_idle"
          when "up"
            @playerBody.gotoAndPlay "up_idle"
          when "down"
            @playerBody.gotoAndPlay "down_idle"
          when "right"
            @playerBody.gotoAndPlay "right_idle"
          else
    @vX = MAX_VELOCITY  if @vX > MAX_VELOCITY
    @vX = -MAX_VELOCITY  if @vX < -MAX_VELOCITY
    @vY = MAX_VELOCITY  if @vY > MAX_VELOCITY
    @vY = -MAX_VELOCITY  if @vY < -MAX_VELOCITY

  window.Player = Player
) window