label = "Reset buffs"

interactFunc = function()
{
	with (oPlayer)
	{
		buffs = []
		EvaluatePlayerBuffs()	// Order is important!
		EvaluateWeaponBuffs()
		EvaluateOneTimeUseBuffs()
	}
}