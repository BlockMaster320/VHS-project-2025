function IntroScene() {
	if (debug_mode)	// Skip intro for debugging
	{
		RoomTransition(rmLobby)
		return;
	}
	
	new TweenSequence([
		new TweenAction(function() {
			audio_sound_gain(oController.openingAmbiance, 0, 0)
			audio_resume_sound(oController.openingAmbiance)
			audio_sound_gain(oController.openingAmbiance, 1, 5000)
			global.inputState = INPUT_STATE.dialogue
		}),
		TweenWait(3000),
		new TweenAction(function() {
			audio_play_sound(sndAlarmClock, 0, false)
		}),
		TweenWait(audio_sound_length(sndAlarmClock)*1000 + 200),
		new TweenAction(function() {
			oDialogues.startDialogueEx(
				new Dialogue([
					new DialogueLine("...", [], []),
				]),
				DO {
					global.inputState = INPUT_STATE.cutscene
					new TweenSequence([
						
						TweenWait(2000),
						new TweenAction(function() {
							oDialogues.startDialogueEx(
								new Dialogue([
									new DialogueLine("Uhh...", [], [1]),
									new DialogueLine("Wait...", [], [2]),
									new DialogueLine("THE CLONING TECHNIQUES EXAM IS IN 2 HOURS", [], [3]),
									new DialogueLine("Welp", [], [4]),
									new DialogueLine("Let's hope those manifesting classes pay off today.", [], [5]),
									new DialogueLine("Surely more than four people will pass this time.", [], [6]),
									new DialogueLine("Time to go.", [], []),
								]),
								DO {
									global.inputState = INPUT_STATE.cutscene
									audio_sound_gain(oController.openingAmbiance, 0, 1000)
									
									RoomTransition(rmLobby)
								}
							)
						}),
						
					]).start()
				}
			)
		}),
	]).start()
}
