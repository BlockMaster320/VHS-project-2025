function Dialogue(_lines, _cond = function(){ return true }, _endDlgFunc = function(instance){}) constructor
{
	lines = _lines
	condition = _cond
	seen = false
	
	endDlgFunc = _endDlgFunc
	interactingInstance = noone
}

function DialogueLine(_text, _answers, _next, _endLineFunc = []) constructor
{
	text = _text
	answers = _answers // more than 2 not supported
	next = _next
	endLineFunc = _endLineFunc
}

function DialogueSystem() constructor
{
	static dlgs = ds_map_create()
	
	ds_map_add(dlgs, noone, [new Dialogue(
									[
										new DialogueLine("UNKNOWN CHARACTER NAME. PLZ FIX.", [], [])
									])])
									
	ds_map_add(dlgs, CHARACTER_TYPE.mechanic, [
									//0, intro
									new Dialogue([
										/*0*/ new DialogueLine("G-g-g... G-good morning! S-sorry... is th-th-there... I mean, is there s-something I c-c-can help you with?", ["Hello, I heard the metro isn't operating?"], [1]),
										/*1*/ new DialogueLine("Y-yes, I'm a-a-afraid so. The p-p-power has been off... s-since this m-m-morning and we d-d-don't know... why...", [], [2]),
										/*2*/ new DialogueLine("We t-t-tried s-switching it b-b-b... b-back on, but nothing h-happened.", [], [3]),
										/*3*/ new DialogueLine("It's p-probably c-c-connected to that... h-h-hole, that appeared out of n-no-n-nowhere in the wall a-across the p-platform.", [], [4]),
										/*4*/ new DialogueLine("We tried s-ssending a t-technician there... b-b-b-but he c-c-came back p-p-pale and i-i-immeadiately q-q-quit his job.", [], [5]),
										/*5*/ new DialogueLine("It will p-p-p-probably t-take another 3 hours u-u-until another t-team reaches us.", ["What about you? You're a technician as well, aren't you?"], [6]),
										/*6*/ new DialogueLine("M-m-me? I-I-I... d-don't want t-t-to... I-I'm... s-s-scared...", 
												[
													"But I really need to go to school! Can I take a look then?",
													"Ok, I understand... I definitely won't go."
												], 
												[
													7,
													10
												],
												[
													function(){},
													function(){}
												]),
										/*7*/ new DialogueLine("Y-y-you? I-I-I mean... It m-m-might b-be d-dangerous...", 
												[
													"You're right! I'm definitely staying there.", 
													"Naah, I'll be fine, I'm a sorcery student, after all."
												], 
												[
													8,
													9
												], 
												[
													function(){},
													function(){ oLobby.techGuyWorries = true }
												]),
										/*8*/ new DialogueLine("Y-y-yes, y-you d-d-definitely should!", [], []),
										/*9*/ new DialogueLine("I mean... I c-c-cannot s-stop you... B-but p-p-please be c-careful and d-don't t-t-tell anyone!", [], []),
										/*10*/new DialogueLine("Y-y-yes, y-you d-d-definitely s-shouldn't!", [], [])
									]),
									//1, student will stay
									new Dialogue([
										new DialogueLine("T-thank you for y-your p-p-patience, the t-team is on their w-way and will b-b-be there shortly!", [], [])
									]),
									//2, student will go
									new Dialogue([
										new DialogueLine("Y-you're still alive?", [], [])
									])])
	ds_map_add(dlgs, CHARACTER_TYPE.student, [new Dialogue(
									[
										new DialogueLine("Yo, bro! Heading to the academy?", ["Yeah, cloning exam. So far I haven't even passed the first part."], [1]),
										new DialogueLine("No way, I was supposed to take it today too!", [], [2]),
										new DialogueLine("Last time I failed the second part because I forgot my wand and those spare ones at school suck.", ["...! You need a wand? I left mine at home!"], [3]),
										new DialogueLine("Well, lucky you, the metro is stuck anyway.", ["What do you mean?"], [4]),
										new DialogueLine("I dunno, ask the tech guy with a mustache. Imma hit the gym now!", [], [5]),
										new DialogueLine("Oh yeah, gym!", [], [])
									],,
									function(instance)
									{
										with(instance) 
										{
											findPathPosition(320, 500)
											exiting = true
											oController.studentLeft = true
										}
									})
									])
									
	ds_map_add(dlgs, CHARACTER_TYPE.passenger1, [new Dialogue(
									[
										new DialogueLine("Nečum.", [], [])
									]), new Dialogue(
									[
										new DialogueLine("Uh.", [], [])
									])])
	ds_map_add(dlgs, CHARACTER_TYPE.playerCleaner, [//not the best data type for this, but oh well, i'm not changing it now - maybe next time
										//0, first time seeing the boss
										new Dialogue([
											new DialogueLine("Think, think... What could have possibly gone wrong...", [], [1]),
											new DialogueLine("Let A and B be closed sets and let F: A -> B be a mapping. We say that F is a cloning if—", ["Excuse me, would you mind if I swi—"], [2]),
											new DialogueLine("AH, YOU!", [], [3]),
											new DialogueLine("I have tolerated your little adventurous soul for far too long.", [], [4]),
											new DialogueLine("You want to turn this on, huh?", [], [5]),
											new DialogueLine("HOW ABOUT I TURN YOU INTO DUST INSTEAD?", [], [])
										]),
										
										//new DialogueLine("", [], [])
										//1, 2nd+ time seeing the boss
										new Dialogue([
												new DialogueLine("I KNEW YOU WOULD COME BACK.", [], [])
											]),
										
										//2, boss defeated
										new Dialogue([
											new DialogueLine("I guess now I'll have to come clean about this...", [], [1]),
											new DialogueLine("I was once a sorcery student too, but this was the only job I could get.", [], [2]),
											new DialogueLine("I wanted to make things easier today by cloning myself to clean faster.", [], [3]),
											new DialogueLine("But it's been a long time, and I guess I messed it up.", [], [4]),
											new DialogueLine("I was trying to fix it secretly, but you kept turning on the cameras.", [], [5]),
											new DialogueLine("Now I'll lose my job...", ["Maybe I can help you? But could you lend me your wand?"], [])
										]),
										
										//3,4,5, death
										new Dialogue([
											new DialogueLine("I found you unconscious!", [], [1]),
											new DialogueLine("It's dangerous downstairs, stay here!", [], [])
										]),
										new Dialogue([
											new DialogueLine("You probably got lost, but it's alright. I got you back to safety.", [], [1]),
											new DialogueLine("Don't be reckless again.", [], [])
										]),
										new Dialogue([
											new DialogueLine("Are you alright? You could have been hurt!", [], [1]),
											new DialogueLine("Please be more careful!", [], [])
										]),
										
										//6,7,8, death after seeing the boss
										new Dialogue([
											new DialogueLine("You youngsters... I hope you've learned your lesson.", [], [])
										]),
										new Dialogue([
											new DialogueLine("Stick to your notes, little boy.", [], [])
										]),
										new Dialogue([
											new DialogueLine("Stop meddling in things that are none of your business.", [], [])
										]),
										
										//9, easter egg death
										new Dialogue([
											new DialogueLine("What a sigma.", [], [])
										])
										
										])
	ds_map_add(dlgs, CHARACTER_TYPE.shopkeeper, [
									new Dialogue([new DialogueLine("...", [], [])]),
									new Dialogue(
									[
										new DialogueLine("Found these laying around. I will let you take one if you ask nicely.", ["Can i please take one?", "Haha make me."], [1, 2]),
										new DialogueLine("Of course :)", [], []),
										new DialogueLine("tady bude animace jak ho slapne", [], []),
									])])
	ds_map_add(dlgs, CHARACTER_TYPE.escalatorDialogue,
								[
									new Dialogue(
									[
										new DialogueLine("The escalator entry is powered off.", [], [1]),
										new DialogueLine("There has to be a power switch somewhere.", [], [])
									])
								] )
}

// @return index from the dialogue array for the current character, noone for no dialogue
function SelectDlg(_NPCType)
{
	switch (_NPCType){
		case CHARACTER_TYPE.passenger1:
			return irandom(array_length(dialogues.dlgs[? CHARACTER_TYPE.passenger1]) - 1)
		case CHARACTER_TYPE.playerCleaner:
			if (room == rmBossFight){
				if (oBossFight.state == BOSSFIGHT_STATE.startedTalking){
					if(!dialogues.dlgs[? _NPCType][0].seen)
						return 0
					return 1
				}
				if (oBossFight.state == BOSSFIGHT_STATE.defeated){
					return 2
				}
				return 9 // SHOULDN'T HAPPEN
			}
			if (room == rmLobby){
				if (global.inputState != INPUT_STATE.cutscene) return noone
				if (irandom(99) == 0) return 9
				if(!dialogues.dlgs[? _NPCType][0].seen)
					return irandom_range(3, 5)
				return irandom_range(6, 8)
			}
		case CHARACTER_TYPE.shopkeeper:
			if (room == rmLobby)
				return 0
			return 1
		case CHARACTER_TYPE.student:
			if (!dialogues.dlgs[? _NPCType][0].seen)
				return 0
			return noone
		case CHARACTER_TYPE.mechanic:
			if (!dialogues.dlgs[? _NPCType][0].seen)
				return 0
			if (oLobby.techGuyWorries)
				return 2
			return 1
		default:
			return 0
	}
}

function StartDlg(_NPCType, _npcInstance = noone)
{	
	if (!ds_map_exists(dialogues.dlgs, _NPCType)) // Unknown NPC name, show placeholder dialogue - T.N. IMO this does not work
		_NPCType = noone
	
	var dlgIdx = SelectDlg(_NPCType)
	if (dlgIdx == noone) {return}
	current_dialogue = dialogues.dlgs[? _NPCType][dlgIdx]
	current_dialogue.interactingInstance = _npcInstance
	
	SetCurrentLine(0)
	talking = true
	if (global.inputState != INPUT_STATE.cutscene){
		global.inputState = INPUT_STATE.dialogue
	}
}

function StartDlgEx(_dialogue)
{
	current_dialogue = _dialogue
	SetCurrentLine(0)
	talking = true
	if (global.inputState != INPUT_STATE.cutscene){
		global.inputState = INPUT_STATE.dialogue
	}
}

function EndDlg()
{
	interactDelay.reset()
	
	talking = false
	if (room != rmMenu) // Hotfix
		global.inputState = INPUT_STATE.playing
	waiting_for_answer = false
	current_dialogue.seen = true
	
	if (instance_exists(current_dialogue.interactingInstance))
		current_dialogue.endDlgFunc(current_dialogue.interactingInstance)
	current_dialogue = noone
	interactingInstance = noone
	
	oPlayer.ignoreInputBuffer.reset() // Don't shoot right after exiting dialogue when clicking with LMB
	
	DisableDlgOptions()
}

function SetCurrentLine(_lineIdx)
{
	if (_lineIdx == undefined){
		current_line = undefined
		return
	}
	current_line = current_dialogue.lines[_lineIdx]
	waiting_for_answer = array_length(current_line.answers) > 0 ? true : false
	timer = 0
	DisableDlgOptions()
}

function DlgTimerTick()
{
	if (timer <= 2*string_length(current_line.text))
	{
		timer++
		var pitch = random_range(.98, 1.02)
		audio_play_sound(sndDialogue, 0, false, 1, 0, pitch)
	}
}

function DlgTimerSkip()
{
	if (timer < 2*string_length(current_line.text)){
		timer = 2*string_length(current_line.text)
		return true
	}
	return false
}

function GetNextDlgLine(_optionIdx = 0)
{
	if (!array_length(current_line.next) || _optionIdx < 0 || _optionIdx >= array_length(current_line.next))
		return false

	SetCurrentLine(current_line.next[_optionIdx])
	if (current_line == undefined)
		return false

	return true
}

function GetSelectedDlgOptionIdx(_x, _y)
{
	for (var i = 0; i < array_length(current_line.answers); ++i){
		if (options[i].isClicked(_x, _y))
		{
			audio_play_sound(sndClick, 0, false)
			return i
		}
	}
}

function StepDlgOptions(_x, _y)
{
	if (timer >= 2*string_length(current_line.text)){
		for (var i = 0; i < array_length(current_line.answers); ++i){
			options[i].active = true
			options[i].text = current_line.answers[i]
			options[i].selected = options[i].isClicked(_x, _y)
		}
	}
}

function DisableDlgOptions()
{
	for (var i = 0; i < array_length(options); ++i){
		options[i].active = false
	}
}

function EndLineFunction(_optionIdx)
{
	if (array_length(current_line.endLineFunc) > 0){
		current_line.endLineFunc[_optionIdx]()
	}
}
