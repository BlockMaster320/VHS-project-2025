myBuff = -1

function setupBuffPickupRarity(rarity)
{
	//var buffID = GetBuffIndex(rarity)
	var buffID = GetBuffIndex(rarity)
	setupBuffPickupID(buffID)
}

function setupBuffPickupID(buffID)
{
	//myBuff = structCopy(global.buffDatabase[buffID])
	myBuff = BuffCreate(buffID)
	myBuff.buffRandomize()
	sprite_index = myBuff.sprite
}

connectedInstances = []	// On pickup, destroy other choices