function DeathScene() {
	
	// this code spawns NPC
	var cleaner = instance_create_layer(x + 64, y, "Instances", oNPC)
	with(cleaner) { characterCreate(CHARACTER_TYPE.playerCleaner) }
	
	global.inputState = INPUT_STATE.cutscene
	new TweenSequence([
		// start cinema borders
		oCinemaBorders.cinema.Set(CinemaBordersState.CINEMA).GetTween(),
		// TODO: animate cleaner to playerF
		
		// TODO: grap player
		// TODO: animate cleaner with player
		// hide scene
		oCinemaBorders.cinema.Set(CinemaBordersState.WHOLE).GetTween(),
		// move to new scene
		new TweenAction(function() {
			room_goto(rmLobby);
			oCinemaBorders.cinema.Set(CinemaBordersState.NONE).Start()
			// TODO: there is triggered dialog
		}),
	]).start()
}


// start
// cleaner spawn at the slightly right
// move left
// in the middle, player grabbed
// move left
// end

// needed -> npc with move animation & idle animation
// 