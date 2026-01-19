Constants()

// Floor state ----------------------------
currentFloor = 0;

//gameFPS = display_get_frequency()
gameFPS = 60
//gameFPS = 500
game_set_speed(gameFPS, gamespeed_fps)	// Experimental
defaultGameSpeed = 60 / gameFPS
global.gameSpeed = defaultGameSpeed

window_set_cursor(cr_cross)
//window_set_cursor(cr_none)
//cursor_sprite = sCursor
display_set_timing_method(tm_sleep)		// Turn off vsync

global.inputState = INPUT_STATE.playing

//projectilePool = []

WeaponsInit()
buffRarityIndexes = [BUFF.commonIndex, BUFF.rareIndex]

show_debug_overlay(true)

draw_set_font(fntGeneric)

// Custom alarm system
alarms = []	// Array of "Alarm" structs

// Procedural pathfinding
wallGrid = undefined
pfGrid = undefined

// Lighting -------------------------------------
lightSurface = -1
draw_set_circle_precision(32)
timeLocLight = shader_get_uniform(shLightFilter, "time")
safetyMargin = 10
//timeLocShadow = shader_get_uniform(shShadowFilter, "time")

// Pixel art upscaling --------------------------------
application_surface_draw_enable(false)
upscaleMult = 4
windowWidthPrev = window_get_width()
windowHeightPrev = window_get_height()
guiSurf = surface_create(cameraW, cameraH)
guiUpscaledSurf = -1
updateUpscaleFactor()
surfaceDrawPositionX = 0
surfaceDrawPositionY = 0
fullscreenPrev = window_get_fullscreen()
appWindowXprev = window_get_x()
appWindowYprev = window_get_y()

// Sound ----------------------------------------------

// Music
#macro actionMusicFightGain 1
#macro actionMusicRestGain .4
actionMusic = audio_play_sound(sndActionMusic, 0, true, 0)
audio_pause_sound(actionMusic)

// Ambiance
openingAmbiance = audio_play_sound(sndOpeningAmbiance, 0, true)
audio_pause_sound(openingAmbiance)
subwayAmbiance = audio_play_sound(sndSubwayAmbiance, 0, true)
audio_pause_sound(subwayAmbiance)

// Particle systems ----------------------------
walkDustSys = part_system_create()
walkDust = part_type_create()
walkDustSpawnFreq = 2.41	// times per second
part_type_size(walkDust,1,2,0,0)
part_type_life(walkDust,30,60)
part_type_speed(walkDust,.4,.8,-.01,0)
part_type_alpha2(walkDust, .5, 0)
//part_type_gravity(walkDust,.002,90)
part_type_sprite(walkDust,sDust,false,false,true)

// Highlight if there is a new interaction
questNPC = CHARACTER_TYPE.student

prevRoom = rmLobby

//
instance_create_layer(-50,-50,"Instances", oPlayer)

// Custscenes
introCutscene = true
IntroScene()
