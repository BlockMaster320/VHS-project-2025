function Input(inputState)
{
	up = 0
	down = 0
	left = 0
	right = 0
	
	for (var i = 0; i < INVENTORY_SIZE; i++)
		selectSlot[i] = 0
	scrollSlot = 0
	
	escapeButton = 0
	
	switch (inputState)
	{
		case INPUT_STATE.playing:
		
			// Movement
			up = keyboard_check(vk_up) or keyboard_check(ord("W")) or gamepad_button_check(0,gp_padu)
			down = keyboard_check(vk_down) or keyboard_check(ord("S")) or gamepad_button_check(0,gp_padd)
			left = keyboard_check(vk_left) or keyboard_check(ord("A")) or gamepad_button_check(0,gp_padl)
			right = keyboard_check(vk_right) or keyboard_check(ord("D")) or gamepad_button_check(0,gp_padr)
	
			// Weapon slots
			for (var i = 0; i < INVENTORY_SIZE; i++)
				selectSlot[i] = keyboard_check_pressed(ord(string(i+1)))
				
			scrollSlot = mouse_wheel_up() - mouse_wheel_down()
			
			break
			
		case INPUT_STATE.menu:
			break
	}

	escapeButton = keyboard_check_pressed(vk_escape)
}