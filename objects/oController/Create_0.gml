Constants()

global.gameSpeed = 1
//game_set_speed(240, gamespeed_fps)
//global.gameSpeed = 0.25

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
windowHeightPrev = window_get_width()
guiSurf = surface_create(cameraW, cameraH)
guiSurf4x = surface_create(cameraW*4, cameraH*4)	// Hacky way to downscale pixel art font
guiUpscaledSurf = -1
updateUpscaleFactor()

// Set default window scale to nice multiple
//window_set_size(cameraW * 3, cameraH * 3)

prevRoom = rmLobby
room_goto(rmLobby)
//room_goto(rmDebug)
//room_goto(rmGame)
