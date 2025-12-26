function Input()
{
	up = 0
	down = 0
	left = 0
	right = 0
	primaryButton = 0
	secondaryButton = 0	
	selectSlot = 0
	swapSlot = 0
	scrollSlot = 0
	escapeButton = 0
	next = 0
	clicked = 0
	menuInteraction = 0
	menuInteractionPress = 0
	pause = 0
	
	// UI
	gui_x = 0
	gui_y = 0
	gui_pressed = 0

	switch (global.inputState)
	{
		case INPUT_STATE.playing:
		
			// Movement
			up = keyboard_check(vk_up) or keyboard_check(ord("W")) or gamepad_button_check(0,gp_padu)
			down = keyboard_check(vk_down) or keyboard_check(ord("S")) or gamepad_button_check(0,gp_padd)
			left = keyboard_check(vk_left) or keyboard_check(ord("A")) or gamepad_button_check(0,gp_padl)
			right = keyboard_check(vk_right) or keyboard_check(ord("D")) or gamepad_button_check(0,gp_padr)
			
			// Weapon usage
			primaryButton = mouse_check_button(mb_left)
			primaryButtonPress = mouse_check_button_pressed(mb_left)
			secondaryButton = mouse_check_button(mb_right)
	
			// Weapon slots
			//for (var i = 1; i <= inventorySize; i++)
			//	if (keyboard_check_pressed(ord(string(i))))
			//		selectSlot = i
			swapSlot = keyboard_check_pressed(vk_space)
				
			scrollSlot = mouse_wheel_up() - mouse_wheel_down()
			
			interact = keyboard_check_pressed(ord("E"))
			
			aimDir = point_direction(oPlayer.x, oPlayer.y, device_mouse_x(0), device_mouse_y(0));
			
			break
			
			
		case INPUT_STATE.menu:
		case INPUT_STATE.pausedDialogue:
			gui_x = device_mouse_x_to_gui(0) * guiToCamera
			gui_y = device_mouse_y_to_gui(0) * guiToCamera
			gui_pressed = mouse_check_button_pressed(mb_left)
			
	
			break
			
			
		case INPUT_STATE.dialogue:
		
			next = keyboard_check_pressed(vk_space) or keyboard_check_pressed(ord("E")) or mouse_check_button_pressed(mb_left)
			clicked = mouse_check_button_pressed(mb_left)
			
			break
			
		case INPUT_STATE.cutscene:
		
			break
	}

	pause = keyboard_check_pressed(vk_escape) or keyboard_check_pressed(ord("P"))
}