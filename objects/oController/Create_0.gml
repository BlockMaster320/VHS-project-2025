Constants()

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

// Procedural pathfinding
wallGrid = undefined
pfGrid = undefined

// Pixel art upscaling --------------------------------
application_surface_draw_enable(false)
upscaleMult = 4
windowWidthPrev = window_get_width()
windowHeightPrev = window_get_height()
guiSurf = surface_create(cameraW, cameraH)
guiSurf4x = surface_create(cameraW*6, cameraH*6)	// Hacky way to downscale pixel art font
guiUpscaledSurf = -1
updateUpscaleFactor()

// Set default window scale to nice multiple
//window_set_size(cameraW * 3, cameraH * 3)

prevRoom = rmLobby
room_goto(rmLobby)
//room_goto(rmDebug)
//room_goto(rmGame)
