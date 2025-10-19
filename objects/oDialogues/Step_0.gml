Input()
if (!talking) {
	if (!interact) exit

	with (oPlayer){
		other.closest_NPC = instance_place(x, y, oNPC)
		if (other.closest_NPC == noone) exit
	}

	dialogues.StartDialogue(closest_NPC.name)
	talking = true
	current_line = dialogues.GetLine(0)
	global.inputState = INPUT_STATE.dialogue
} else {
	if (!next) exit
	
	if (!array_length(current_line.next)) {
		talking = false
		global.inputState = INPUT_STATE.playing
	} else {
		current_line = dialogues.GetLine(current_line.next[0])
	}
}
