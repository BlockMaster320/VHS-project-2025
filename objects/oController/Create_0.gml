Constants()

global.gameSpeed = 1
//game_set_speed(120, gamespeed_fps)
//global.gameSpeed = 0.5

global.inputState = INPUT_STATE.playing

//projectilePool = []

WeaponsInit()
BuffsInit()

show_debug_overlay(true)

draw_set_font(fntGeneric)

application_surface_draw_enable(false)
//display_set_gui_size(window_get_width(), window_get_height())
//display_set_gui_size(cameraW, cameraH)
upscaleMult = 4
windowWidthPrev = window_get_width()
windowHeightPrev = window_get_width()
updateUpscaleFactor()

room_goto(rmLobby)
