label = "Reset buffs"

interactFunc = function()
{
	with (oPlayer)
	{
		buffs = []
		EvaluatePlayerBuffs()
		EvaluateWeaponBuffs()
		EvaluateOneTimeUseBuffs()
	}
}