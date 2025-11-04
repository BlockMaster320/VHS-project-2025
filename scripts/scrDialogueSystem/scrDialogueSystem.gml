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
	ds_map_add(dlgs, "", [new Dialogue(
									[
										new DialogueLine("JMÉNO UNDEFINED. OPRAV TO!", [], [])
									])])
	ds_map_add(dlgs, "Franta", [new Dialogue(
									[
										new DialogueLine("Čau kámo.", [], [1]),
										new DialogueLine("Pěkné plíce.", [], [2]),
										new DialogueLine("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", [], [3]),
										new DialogueLine("Půjčíš mi svou botu?", ["Jasně, tady ji máš.", "Ne."], [4, 5]),
										new DialogueLine("Dík moc, jsi frajer", [], []),
										new DialogueLine("Tak doufám, že se ti rozvážou tkaničky.", [], [])
									])])
								
									
	static current_dialogue = noone
	
	static StartDialogue = function(_NPCName)
	{
		
		current_dialogue = dlgs[? _NPCName][0]
		return GetLine(0)
	}
	
	static GetLine = function(_lineIdx)
	{
		return current_dialogue.lines[_lineIdx]
	}
}
