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
									
	ds_map_add(dlgs, CHARACTER_TYPE.passenger1, [new Dialogue(
									[
										new DialogueLine("Nečum.", [], [])
									])])
								
									
	static current_dialogue = noone
	
	static StartDialogue = function(_NPCType)
	{
		if (!ds_map_exists(dlgs, _NPCType)) // Unknown NPC name, show placeholder dialogue
			_NPCType = noone
		current_dialogue = dlgs[? _NPCType][0]
		return GetLine(0)
	}
	
	static GetLine = function(_lineIdx)
	{
		return current_dialogue.lines[_lineIdx]
	}
}
