if (!talking) {
	if (!oController.interact) exit

	with (oPlayer){
		other.closest_NPC = instance_place(x, y, oNPC)
		if (other.closest_NPC == noone) exit
	}

	talking = true
	current_line = dialogues.StartDialogue(closest_NPC.name)
	global.inputState = INPUT_STATE.dialogue
	timer = 0
} else if (!waiting_for_answer){
	if (!oController.next){
		if (timer <= 2*string_length(current_line.text)){
			timer++
		}
		exit
	}
	
	if (timer < 2*string_length(current_line.text)){
		timer = 2*string_length(current_line.text)
	} else {
		if (!array_length(current_line.next)) {
			talking = false
			global.inputState = INPUT_STATE.playing
			exit
		} else {
			current_line = dialogues.GetLine(current_line.next[0])
			timer = 0
		}
	}	
} else {
	var _x = device_mouse_x_to_gui(0)
	var _y = device_mouse_y_to_gui(0)

	if (oController.next){
		if (timer < 2*string_length(current_line.text)){
			timer = 2*string_length(current_line.text)
		} else if (oController.clicked){
			for (var i = 0; i < array_length(current_line.answers); ++i){
				if (options[i].isClicked(_x, _y)){
					current_line = dialogues.GetLine(current_line.next[i])
					timer = 0
					break
				}
			}
		}
	}
}

if (timer <= 2*string_length(current_line.text)){
	timer++
}
if (!array_length(current_line.answers)) {
	waiting_for_answer = false
	
	for (var i = 0; i < array_length(options); ++i){
		options[i].active = false
	}
} else {
	waiting_for_answer = true
	
	if (timer >= 2*string_length(current_line.text)){
		var _x = device_mouse_x_to_gui(0)
		var _y = device_mouse_y_to_gui(0)
		for (var i = 0; i < array_length(current_line.answers); ++i){
			options[i].active = true
			options[i].text = current_line.answers[i]
			if (options[i].isClicked(_x, _y)){
				options[i].selected = true
			} else {
				options[i].selected = false
			}
		}
	}
}
