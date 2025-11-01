myBuff = -1

function setupBuffPickupRarity(rarity)
{
	var buffID = GetBuffIndex(rarity)
	setupBuffPickupID(buffID)
}

function setupBuffPickupID(buffID)
{
	myBuff = json_parse(global.buffsJSON[buffID])
	//myBuff.buffRandomize() // Crashes the game for now
	sprite_index = myBuff.sprite
}