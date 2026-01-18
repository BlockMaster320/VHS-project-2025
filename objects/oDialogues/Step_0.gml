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
	if (waiting_for_answer){
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
	} else if (oController.next && !DlgTimerSkip() && !GetNextDlgLine()){
		debug("Ending dialogue for character")
		EndDlg()
		if (is_callable(onComplete)) {
			debug("Calling onComplete of the dialogue...")
			onComplete()
		}
		onComplete = DO NOTHING
	}
}
