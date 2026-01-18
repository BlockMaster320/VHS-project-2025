function IntroScene() {
	new TweenSequence([
		TweenWait(1000),
		new TweenAction(function() {
			oDialogues.startDialogueEx(
				new Dialogue([
					new DialogueLine("Lying in my bed...", [], [1]),
					new DialogueLine("Shutting down alarm clock...", [], [2]),
					new DialogueLine("I realized something reeeeaaaalllly important!", [], [3]),
					new DialogueLine("O.O", [], [4]),
					new DialogueLine("I almost overslept my last exam of cloning techniques!", [], [5]),
					new DialogueLine("I need to get to the school as fast as i can, ...", [], [6]),
					new DialogueLine("... so subway is the only solution ...", [], [7]),
					new DialogueLine("... and I hope nothing bad will happen.", [], []),
				]),
				DO {
					getCinemaBorders().SetInstantly(CinemaBordersState.WHOLE)
					RoomTransition(rmLobby)
				}
			)
		})
	]).start()
}
