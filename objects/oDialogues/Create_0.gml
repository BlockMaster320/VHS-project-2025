DlgConstants()
dialogues = new DialogueSystem()

closest_NPC = noone
talking = false

// textbox
waiting_for_answer = false
current_line = noone

// options - maximum of 2 options just to give the illusion of choice
highlighted = 0
for (var i = 0; i < 2; ++i){
	options[i] = instance_create_layer(0, 0, "Instances_1", oDialogueOption)
	options[i].idx = i
}
