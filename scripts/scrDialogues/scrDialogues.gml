function Dialogues() constructor
{
	static dlgs = ds_map_create()
	ds_map_add(dlgs, "Franta", [new Dialogue([new DialogueLine("Čau kámo", [], []) ])])
	current_dialogue = noone
	
	static StartDialogue = function(_NPCName)
	{
		current_dialogue = dlgs[? _NPCName][0]
	}
	
	static GetLine = function(_lineIdx)
	{
		return current_dialogue.lines[_lineIdx]
	}
}
