if (!talking) {
	if (!instance_exists(oPlayer)) exit
	if (instance_exists(closest_NPC)){
		closest_NPC.inRange = false
	}
	
    closest_NPC = instance_nearest(oPlayer.x, oPlayer.y, oNPC);
	if (!instance_exists(closest_NPC) || closest_NPC == noone) exit;
	var _distToClosestNPC = point_distance(oPlayer.x, oPlayer.y, closest_NPC.x, closest_NPC.y);
	if (_distToClosestNPC > INTERACTION_DISTANCE) {
		exit;
	}
	closest_NPC.inRange = true
	
	if (!oController.interact) exit

	/*
	with (oPlayer){
		other.closest_NPC = instance_place(x, y, oNPC)
		if (other.closest_NPC == noone) exit
	}*/
	
	StartDlg(closest_NPC.characterType)
} else {
	DlgTimerTick()
	
	var skipClicked = current_dialogue.seen && oController.clicked && mouseOnSkip
	if (skipClicked || (!waiting_for_answer && oController.next && !DlgTimerSkip())){
		if (!skipClicked && GetNextDlgLine()){
			exit
		}
		debug("Ending dialogue for character")
		EndDlg()
		
		if (instance_exists(closest_NPC) and closest_NPC.characterType == oController.questNPC)
		{	// Change quest marker
			// Not very robust solution, but good enough for now
			switch (closest_NPC.characterType)
			{
				case CHARACTER_TYPE.student:
					oController.questNPC = CHARACTER_TYPE.mechanic
					break
					
				case CHARACTER_TYPE.mechanic:
					oController.questNPC = noone
					break
			}
		}
		
		if (is_callable(onComplete)) {
			debug("Calling onComplete of the dialogue...")
			onComplete()
		}
		onComplete = DO NOTHING
	} else if (waiting_for_answer){
		var _x = device_mouse_x_to_gui(0) * guiToCamera
		var _y = device_mouse_y_to_gui(0) * guiToCamera
		StepDlgOptions(_x, _y)
		if (oController.next){
			if (!DlgTimerSkip() && oController.clicked){
				var _optIdx = GetSelectedDlgOptionIdx(_x, _y)
				if (_optIdx != undefined && !GetNextDlgLine(_optIdx)){
					EndDlg()
					exit
				}
			}
		}
	}
}
