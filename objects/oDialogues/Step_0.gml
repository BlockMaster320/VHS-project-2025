Input()

if (!interact) exit

with (oPlayer){
	closest_NPC = instance_place(x, y, oNPC)
	if (closest_NPC == noone) exit
	
	show_debug_message(closest_NPC.name)
}
