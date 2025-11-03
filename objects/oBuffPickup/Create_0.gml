myBuff = -1

function setupBuffPickupRarity(rarity)
{
	var buffID = GetBuffIndex(rarity)
	setupBuffPickupID(buffID)
}

function setupBuffPickupID(buffID)
{
	myBuff = structCopy(global.buffDatabase[buffID])
	myBuff.buffRandomize()
	sprite_index = myBuff.sprite
}