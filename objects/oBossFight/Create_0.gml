oPlayer.x = 775;
oPlayer.y = 850;

enum BOSSFIGHT_STATE{
	entered, startedTalking, fighting, defeated	
}

state = BOSSFIGHT_STATE.entered

cleanerEnemy = noone
clones = ds_list_create()

revealSound = audio_play_sound(sndBigReveal, 0, false)
audio_stop_sound(revealSound)

removeClones = function(){
	with (oEnemy) {
		var _index = ds_list_find_index(oBossFight.clones, id);
		if (_index != -1) {
			ds_list_delete(oBossFight.clones, _index)
			id.onDeathEvent()
		}
	}
}

deactivateCleaner = function(){
	if (cleanerEnemy != noone){
		instance_deactivate_object(oEnemy)
	}
}
