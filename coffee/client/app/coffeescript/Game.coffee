KEYCODE_ENTER = 13
KEYCODE_SPACE = 32
KEYCODE_UP = 38
KEYCODE_LEFT = 37
KEYCODE_RIGHT = 39
KEYCODE_DOWN = 40
KEYCODE_W = 87
KEYCODE_A = 65
KEYCODE_S = 83
KEYCODE_D = 68
lfHeld = undefined
rtHeld = undefined
fwdHeld = undefined
dnHeld = undefined
canvas = undefined
stage = undefined
tileset = undefined
mapData = undefined
loader = undefined
player = undefined
playerSprite = undefined
level = undefined
gps = undefined
preload = undefined

init = ->
  getGPSLocation()
  canvas = document.getElementById("gameCanvas")
  stage = new createjs.Stage(canvas)

  messageField = new createjs.Text("Loading", "bold 24px Arial", "#FFFFFF")
  messageField.maxWidth = 1000
  messageField.textAlign = "center"
  messageField.x = canvas.width / 2
  messageField.y = canvas.height / 2

  manifest = [
    src: "images/runningRpg.png"
    id: "player"
  ]
  loader = new createjs.LoadQueue(false)
  loader.addEventListener "complete", handleComplete
  loader.loadManifest manifest

  stage.addChild messageField
  stage.update() #update the stage to show text

handleComplete = (event) ->
  data = new createjs.SpriteSheet(
    images: [loader.getResult("player")]
    frames:
      regX: 100
      height: 292
      count: 12
      regY: 165 / 2
      width: 165

    animations:
      up: [0, 2, "up"]
      right: [3, 5, "right"]
      down: [6, 8, "down"]
      left: [9, 11, "left"]
      left_idle: [9, 9]
      right_idle: [3, 3]
      up_idle: [0, 0]
      down_idle: [6, 6]
  )

  playerSprite = new createjs.Sprite(data, "right_idle")
  playerSprite.framerate = 10

  doneLoading()

doneLoading = (event) ->
  restart()

handleClick = ->  
  canvas.onclick = null
  stage.removeChild messageField

#reset all game logic
restart = ->
  #hide anything on stage
  stage.removeAllChildren()
  
  #create the player
  player = new Player(playerSprite)
  player.x = canvas.width / 2
  player.y = canvas.height / 2
  
  #reset key presses
  lfHeld = rtHeld = fwdHeld = dnHeld = false
  
  #ensure stage is blank and add the ship
  stage.clear()
  level = new Level(stage)
  stage.addChild player
  
  #start game timer   
  createjs.Ticker.addEventListener "tick", tick  unless createjs.Ticker.hasEventListener("tick")

tick = (event) ->
  keys = []
  
  #handle thrust
  keys.push "up"  if fwdHeld
  keys.push "down"  if dnHeld
  keys.push "left"  if lfHeld
  keys.push "right"  if rtHeld

  player.accelerate keys
  
  #call sub ticks
  player.tick event
  stage.x = -player.x + canvas.width * .5  if player.x > canvas.width * .5
  stage.y = -player.y + canvas.height * .5  if player.y > canvas.height * .5
  stage.update event

#allow for WASD and arrow control scheme
handleKeyDown = (e) ->  
  #cross browser issues exist
  e = window.event  unless e
  switch e.keyCode
    when KEYCODE_SPACE
      shootHeld = true
      false
    when KEYCODE_A, KEYCODE_LEFT
      lfHeld = true
      false
    when KEYCODE_D, KEYCODE_RIGHT
      rtHeld = true
      false
    when KEYCODE_W, KEYCODE_UP
      fwdHeld = true
      false
    when KEYCODE_S, KEYCODE_DOWN
      dnHeld = true
      false
    when KEYCODE_ENTER
      handleClick()  if canvas.onclick is handleClick
      false

handleKeyUp = (e) ->
  e = window.event  unless e
  switch e.keyCode
    when KEYCODE_SPACE
      shootHeld = false
    when KEYCODE_A, KEYCODE_LEFT
      lfHeld = false
    when KEYCODE_D, KEYCODE_RIGHT
      rtHeld = false
    when KEYCODE_W, KEYCODE_UP
      fwdHeld = false
    when KEYCODE_S, KEYCODE_DOWN
      dnHeld = false

gpsDataSuccess = (data) ->
  gps = data.coords
  console.log gps.latitude, gps.longitude
  
getGPSLocation = ->
  navigator.geolocation.getCurrentPosition gpsDataSuccess  if navigator.geolocation

document.onkeydown = handleKeyDown
document.onkeyup = handleKeyUp