oPlayer.x = 775;
oPlayer.y = 850;

enum BOSSFIGHT_STATE{
	entered, startedTalking, fighting, defeated	
}

state = BOSSFIGHT_STATE.entered

cleanerEnemy = noone
cleanerX = 768
cleanerY = 192
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

endgameScene = new TweenSequence([
	new TweenAction(function(){
		var cleanerNPC = instance_create_layer(cleanerX, cleanerY, "Instances", oNPC)
		with (cleanerNPC){ characterCreate(CHARACTER_TYPE.playerCleaner) }
	}),
	new TweenAction(function() {
		audio_sound_gain(oController.actionMusic, 0, 2000)
	}),
	TweenWait(4000),
	new TweenDialogue(CHARACTER_TYPE.playerCleaner),
	getCinemaBorders().Set(CinemaBordersState.WHOLE, function(){
		with (oPlayer) ResetPlayer()
		global.inputState = INPUT_STATE.cutscene
		room_goto(rmMenu)
		oPlayer.x = -1000
		oPlayer.y = -1000
		part_particles_clear(oController.cloneDustSys)
		getCinemaBorders().Set(CinemaBordersState.NONE).Start()
	}).GetTween(),
	TweenWait(1000),
	new TweenAction(function() {
		oController.lobbyMusic = audio_play_sound(sndLobbyMusic, 0, true, 0)
		audio_sound_gain(oController.lobbyMusic, 1, 2000)
	}),
	new TweenDialogueEx(new Dialogue([
		new DialogueLine("...and so I have conquered chaos, restored peace and brought back the electricity.", [], [1]),
		new DialogueLine("Cloning is, indeed, much like life:", [], [2]),
		new DialogueLine("The harder you try to erase every flaw, the more you forget that imperfection is what makes the original real.", [], [3]),
		new DialogueLine("Anyways, here I am, surprisingly on time. Moment of truth...", [], [])		
	])),
	TweenWait(1000),
	new TweenDialogueEx(new Dialogue([
		new DialogueLine("Huh?", [], [1]),
		new DialogueLine("The exam starts in one minute, why is no one there?", [], [2]),
		new DialogueLine("Let's check the email then... Of course I was logged out.", [], [3]),
		new DialogueLine("My password... To hell with MFA... Authenticator... 67...", [], [4]),
		new DialogueLine("AH! New email, delivered 40 minutes ago!", [], [5]),
		new DialogueLine("\"Hey everyone! My cat is sick and I heard the metro is not working anyway,\"", [], []),
	])),
	new TweenAction(function() {
		audio_stop_sound(oController.lobbyMusic)
	}),
	new TweenDialogueEx(new Dialogue([
		new DialogueLine("\"so I'm moving the exam to next week. See you on Tuesday, your teacher :)\"", [], []),
	])),
	TweenWait(6000),
	new TweenDialogueEx(new Dialogue([
		new DialogueLine("...", [], []),
	])),
	TweenWait(3000),
	new TweenAction(function() {
		oController.lobbyMusic = audio_play_sound(sndLobbyMusic, 0, true)
		oController.menuShowCredits1 = true
		menuShowCredits1Alpha = 0
	}),
	TweenWait(3000),
	new TweenAction(function() {
		oController.menuShowCredits2 = true
		menuShowCredits2Alpha = 0
	}),
	TweenWait(3000),
	new TweenAction(function() {
		oController.menuShowCredits3 = true
		menuShowCredits3Alpha = 0
	}),
])
