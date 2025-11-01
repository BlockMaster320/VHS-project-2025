function Range(minimum, maximum) constructor
{
	min_ = minimum
	max_ = maximum
	
	value = 0
	
	function rndmize() { value = random_range(min_, max_) }
}

function Buff() constructor
{
	sprite = sPlaceholderBuff
	descriptionBuff = "Default buff text"
	descriptionDebuff = "Default debuff text"
	rarity = RARITY.common
	
	buffRandomize = function(){ show_debug_message("Buff initiazation and randomization is undefined!") }
	buffActivate = function(){ show_debug_message("Buff function is undefined!") }
}

function GetBuffIndex(rarity)
{
	var start_ = 0
	if (rarity != 0) start_ = oController.rarityIndexes[rarity-1]
	var end_ = oController.rarityIndexes[rarity] - 1
	return random_range(start_, end_)
}