Constants()

global.gameSpeed = 1
//game_set_speed(240, gamespeed_fps)
global.gameSpeed = 0.25

global.inputState = INPUT_STATE.playing

//projectilePool = []

WeaponsInit()
BuffsInit()

show_debug_overlay(true)

draw_set_font(fntGeneric)

// Pixel art upscaling --------------------------------
application_surface_draw_enable(false)
upscaleMult = 4
windowWidthPrev = window_get_width()
windowHeightPrev = window_get_width()
guiSurf = surface_create(cameraW, cameraH)
guiUpscaledSurf = -1
updateUpscaleFactor()

// Set default window scale to nice multiple
//window_set_size(cameraW * 3, cameraH * 3)


room_goto(rmLobby)
//room_goto(rmGame)
