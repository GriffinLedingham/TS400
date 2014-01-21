((window) ->
  Player = (sprite) ->
    @initialize sprite

  p = Player:: = new createjs.Container()
  
  # public properties:
  p.vX
  p.vY
  p.bounds
  p.hit
  p.lastKey
  MAX_VELOCITY = 20
  
  # constructor:
  p.Container_initialize = p.initialize #unique to avoid overiding base class

  p.initialize = (sprite) ->
    @Container_initialize()
    @playerBody = sprite
    @addChild @playerBody
    
    @vX = 0
    @vY = 0

  # public methods:
  p.tick = (event) ->
    
    #move by velocity
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