event_inherited()

interactionFunction = function()
{
	//oDialogues.startDialogue(CHARACTER_TYPE.escalatorDialogue)
	
	var dialogue = new TweenDialogueEx(
							new Dialogue(
							[
								new DialogueLine("The escalator entry is powered off.", [], [1]),
								new DialogueLine("There has to be a power switch somewhere.", [], [])
							])
						)
	dialogue.start()
}

drawSelf = false
repeatedInteraction = true