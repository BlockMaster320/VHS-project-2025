myBuff = -1

function setupBuffPickupRarity(rarity, forbiddenBuffs=[])
{
	//var buffID = GetBuffIndex(rarity)
	var buffID = GetBuffIndex(rarity)
	if (is_array(forbiddenBuffs))
		repeat (30)
		{
			if (array_contains(forbiddenBuffs, buffID))
				buffID = GetBuffIndex(rarity)
			else break
		}
	setupBuffPickupID(buffID)
	return buffID
}

function setupBuffPickupID(buffID)
{
	//myBuff = structCopy(global.buffDatabase[buffID])
	myBuff = BuffCreate(buffID)
	myBuff.buffRandomize()
	sprite_index = myBuff.sprite
}

connectedInstances = []	// On pickup, destroy other choices