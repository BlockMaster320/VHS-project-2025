Constants()

global.gameSpeed = 1
//game_set_speed(120, gamespeed_fps)
//global.gameSpeed = 0.5

global.inputState = INPUT_STATE.playing

projectilePool = []

WeaponsInit()

show_debug_overlay(true)

draw_set_font(fntGeneric)

room_goto(rmGraphicsTesting)