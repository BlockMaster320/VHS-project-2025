function Dialogues() constructor
{
	static dlgs = ds_map_create()
	ds_map_add(dlgs, "Franta", [new Dialogue(
									[
										new DialogueLine("Čau kámo.", [], [1]),
										new DialogueLine("Pěkné plíce.", [], [2]),
										new DialogueLine("Lidské.", [], [])
									])])
	static current_dialogue = noone
	
	static StartDialogue = function(_NPCName)
	{
		current_dialogue = dlgs[? _NPCName][0]
	}
	
	static GetLine = function(_lineIdx)
	{
		return current_dialogue.lines[_lineIdx]
	}
}
