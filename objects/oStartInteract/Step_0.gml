if (keyboard_check_pressed(vk_f11)) window_set_fullscreen(!window_get_fullscreen())

if (mouse_check_button_pressed(mb_left))
{
	room_goto(rmMenu)
	instance_destroy()
}