function Input()
{
	up = 0
	down = 0
	left = 0
	right = 0
	aimDir = 0
	primaryButton = 0
	secondaryButton = 0
	for (var i = 0; i < INVENTORY_SIZE; i++) selectSlot[i] = 0
	scrollSlot = 0
	escapeButton = 0
	next = 0
	menuInteraction = 0
	menuInteractionPress = 0
	pause = 0
	

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
			secondaryButton = mouse_check_button(mb_right)
	
			// Weapon slots
			for (var i = 0; i < INVENTORY_SIZE; i++)
				selectSlot[i] = keyboard_check_pressed(ord(string(i+1)))
				
			scrollSlot = mouse_wheel_up() - mouse_wheel_down()
			
			interact = keyboard_check_pressed(ord("E"))
			
			break
			
			
		case INPUT_STATE.menu:
		
			menuInteraction = mouse_check_button(mb_left)
			menuInteractionPress = mouse_check_button_pressed(mb_left)
		
			break
			
			
		case INPUT_STATE.dialogue:
		
			next = keyboard_check_pressed(vk_space) or keyboard_check_pressed(ord("E"))
			
			break
		
		case INPUT_STATE.dialogueMenu:
		
		
			break
	}
	
	pause = keyboard_check_pressed(vk_escape) or keyboard_check_pressed(ord("P"))
}
