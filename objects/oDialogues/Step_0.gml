Input()

if (!interact) exit

with (oPlayer){
	other.closest_NPC = instance_place(x, y, oNPC)
	if (other.closest_NPC == noone) exit
}

dialogues.StartDialogue(closest_NPC.name)
show_debug_message(dialogues.GetLine(0).text)
