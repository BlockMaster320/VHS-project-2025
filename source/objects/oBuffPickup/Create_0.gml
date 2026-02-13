myBuff = -1
animationOffset = random(1) * 2 * 3.14;
depth = -y;

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
	//myBuff.buffRandomize()
	sprite_index = myBuff.sprite
	setupDrawing()
}

connectedInstances = []	// On pickup, destroy other choices

// Percompute some constants to save on performance (this was actually a bottleneck at one point)
function setupDrawing()
{
	scale = round(.5 * oController.upscaleMult) / oController.upscaleMult
	str = ""
	if (myBuff.descriptionBuff != "") str += "\n" + string(myBuff.descriptionBuff)
	if (myBuff.descriptionDebuff != "") str += "\n" + string(myBuff.descriptionDebuff)
	if (myBuff.descriptionNeutralEffect != "") str += "\n" + string(myBuff.descriptionNeutralEffect)
	strW = string_width(str)
	lineH = font_get_size(draw_get_font()) * scale
	rowAmount = string_count("\n", str)

	textLineOff = 10 * scale
	margin = 5 * scale
	yOff = -20
	w = strW * scale + margin*4
	h = (lineH + textLineOff) * (rowAmount-1) + margin*2 + textLineOff/2

	left = x - w/2
	right = x + w/2
	top = y + yOff - h
	bott = y + yOff
	centerX = x
}