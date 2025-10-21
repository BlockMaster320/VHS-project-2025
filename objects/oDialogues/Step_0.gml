if (!talking) {
	if (!oController.interact) exit

	with (oPlayer){
		other.closest_NPC = instance_place(x, y, oNPC)
		if (other.closest_NPC == noone) exit
	}

	talking = true
	current_line = dialogues.StartDialogue(closest_NPC.name)
} else if (!waiting_for_answer){
	if (!oController.next) exit
	
	if (!array_length(current_line.next)) {
		talking = false
		global.inputState = INPUT_STATE.playing
		exit
	} else {
		current_line = dialogues.GetLine(current_line.next[0])
	}
} else {
	
}

if (!array_length(current_line.answers)) {
	waiting_for_answer = false
	global.inputState = INPUT_STATE.dialogue
	
	for (var i = 0; i < array_length(current_line.answers); ++i){
		options[i].active = false
	}
} else {
	waiting_for_answer = true
	global.inputState = INPUT_STATE.dialogueMenu
	
	for (var i = 0; i < array_length(current_line.answers); ++i){
		options[i].active = true
		options[i].text = current_line.answers[i]
	}
	options[0].selected = true
}
