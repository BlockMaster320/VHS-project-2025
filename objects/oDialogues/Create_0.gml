DlgConstants()
dialogues = new DialogueSystem()
current_dialogue = noone
onComplete = DO NOTHING

closest_NPC = noone
talking = false

// textbox
waiting_for_answer = false
current_line = noone
timer = 0

// options - maximum of 2 options just to give the illusion of choice
highlighted = 0
for (var i = 0; i < 2; ++i){
	options[i] = instance_create_depth(0, 0, 0, oDialogueOption)
	options[i].idx = i
}

mouseOnSkip = false

// TEMP: spawn NPC for testing
//var _test_NPC = instance_create_layer(FLOOR_CENTER_X + 60, FLOOR_CENTER_Y + 20, "Instances", oNPC)
//with(_test_NPC) { characterCreate(CHARACTER_TYPE.mechanic); }

startDialogue = function(_characterType, _onComplete = function() {}) {
	debug("Starting dialogue for character: " + string(_characterType))
	onComplete = _onComplete
	StartDlg(_characterType)	
}

startDialogueEx = function(_dialogue, _onComplete = function() {}) {
	debug("Starting custom dialogue")
	onComplete = _onComplete
	StartDlgEx(_dialogue)	
}