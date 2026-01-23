function Dialogue(_lines, _cond = function(){ return true }) constructor
{
	lines = _lines
	condition = _cond
	seen = false
}

function DialogueLine(_text, _answers, _next) constructor
{
	text = _text
	answers = _answers // more than 2 not supported
	next = _next
}

function DialogueSystem() constructor
{
	static dlgs = ds_map_create()
	
	ds_map_add(dlgs, noone, [new Dialogue(
									[
										new DialogueLine("UNKNOWN CHARACTER NAME. PLZ FIX.", [], [])
									])])
									
	ds_map_add(dlgs, CHARACTER_TYPE.mechanic, [new Dialogue(
									[
										new DialogueLine("Čau kámo.", [], [1]),
										new DialogueLine("Pěkné plíce.", [], [2]),
										new DialogueLine("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", [], [3]),
										new DialogueLine("Půjčíš mi svou botu?", ["Jasně, tady ji máš.", "Ne."], [4, 5]),
										new DialogueLine("Dík moc, jsi frajer", [], []),
										new DialogueLine("Tak doufám, že se ti rozvážou tkaničky.", [], [])
									])])
	ds_map_add(dlgs, CHARACTER_TYPE.student, [new Dialogue(
									[
										new DialogueLine("Yo, bro! Heading to the academy?", ["Yeah, cloning exam. Last shot or I'm out."], [1]),
										new DialogueLine("No way, me too!", [], [2]),
										new DialogueLine("Man, I failed it twice already and I was about to fail it again...", [], [3]),
										new DialogueLine("but I guess those manifesting classes finally paid off.", ["What do you mean?"], [4]),
										new DialogueLine("The metro is stuck or something, idk.", [], [5]),
										new DialogueLine("Ask the tech guy with a mustache, I'm going home.", [], [6]),
										new DialogueLine("Silver league's calling, I can feel it!", [], [])
									])])
									
	ds_map_add(dlgs, CHARACTER_TYPE.passenger1, [new Dialogue(
									[
										new DialogueLine("Nečum.", [], [])
									]), new Dialogue(
									[
										new DialogueLine("Uh.", [], [])
									])])
	ds_map_add(dlgs, CHARACTER_TYPE.playerCleaner, [new Dialogue(
									[
										new DialogueLine("You messed it down there a bit. Be careful, I may not be there next time.", ["I'll be careful.", "Okay"], [1, 1]),
										new DialogueLine("I hope I won't see you down again anymore. And now more cleaning again...", [], [])
									])])
	ds_map_add(dlgs, CHARACTER_TYPE.shopkeeper, [new Dialogue(
									[
										new DialogueLine("Found these laying around. I will let you take one if you ask nicely.", ["Can i please take one?", "Haha make me."], [1, 2]),
										new DialogueLine("Of course :)", [], []),
										new DialogueLine("tady bude animace jak ho slapne", [], []),
									])])
}

function SelectDlg(_NPCType)
{
	switch (_NPCType){
		case CHARACTER_TYPE.passenger1:
			return irandom(array_length(dialogues.dlgs[? CHARACTER_TYPE.passenger1]) - 1)
		default:
			return 0
	}
}

function StartDlg(_NPCType)
{
	if (!ds_map_exists(dialogues.dlgs, _NPCType)) // Unknown NPC name, show placeholder dialogue - T.N. IMO this does not work
		_NPCType = noone
		
	current_dialogue = dialogues.dlgs[? _NPCType][SelectDlg(_NPCType)]
	
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
	talking = false
	global.inputState = INPUT_STATE.playing
	waiting_for_answer = false
	current_dialogue.seen = true
	current_dialogue = noone
	
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
			return i
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
