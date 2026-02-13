event_inherited();

if (global.SHOW_PATH_GRID)
{
	draw_set_alpha(.2)
	if (!is_undefined(oController.pfGrid))
		mp_grid_draw(oController.pfGrid)
	draw_set_alpha(1)
}

// Draw current weapon
var activeWeapon = -1
var weaponOff = 0
for (var i = 0; i < inventorySize; i++)
	if (weaponInventory[i].active)
	{
		weaponInventory[i].draw(weaponAlpha, weaponOff)
		weaponOff += dualWield*2	// Offset weapon when drawing multiple over each other
		activeWeapon = weaponInventory[i]
	}
if (tempWeaponSlot.active) tempWeaponSlot.draw()


//draw_text(x, y - 20, $"Health: {hp}")

// Reload / cooldown state
if (activeWeapon != -1)
	drawReloadState(activeWeapon,,,.5)


// UI --------------------------------------------------------
if (room == rmLobby or room == rmMenu) return;

if (global.inputState != INPUT_STATE.dialogue)
{

surface_set_target(oController.guiSurf)

var margin = 2 * TILE_SIZE
var rightX = cameraW - margin
var bottomY = cameraH - margin

var showStats = false
var showStatsSlot = 0
var mouseX = device_mouse_x_to_gui(0) * guiToCamera
var mouseY = device_mouse_y_to_gui(0) * guiToCamera
//draw_circle(mouseX, mouseY, 20, false)

// Inventory ----------------------------------------

var size = 1.6 * TILE_SIZE
var center = size/2

// Inventory dark background
draw_set_color(c_black)
draw_set_alpha(.9)

draw_rectangle(rightX - size*inventorySize, bottomY - size, rightX, bottomY + 1., false)

draw_set_alpha(1)
draw_set_color(c_white)


draw_set_halign(fa_center)

for (var i = 0; i < inventorySize; i++)
{
	var xx = rightX - (size * (inventorySize-1 - i)) - center
	var yy = bottomY - center
	
	// Show durability
	if (weaponInventory[i].durabilityMult != 0)
	{
		var weaponDurFac = weaponInventory[i].remainingDurability / 1
		draw_set_alpha(.8)
		draw_rectangle(xx - center + .5, yy - center, lerp(xx-center, xx+center, weaponDurFac), yy + center + 1., false)
		draw_set_alpha(1)
	}
	
	// Show weapon stats
	if (point_in_rectangle(mouseX, mouseY, xx-center+.5, yy-center, xx+center, yy+center+1.))
	{
		showStats = true
		showStatsSlot = i
	}
	
	drawReloadState(weaponInventory[i], xx, yy+5, 1)
	
	//Show weapon sprite
	var _sprite = weaponInventory[i].sprite;
	xx = xx + sprite_get_xoffset(_sprite) - sprite_get_width(_sprite) / 2 + 1;	// center the weapon sprite
	yy = yy + sprite_get_yoffset(_sprite) - sprite_get_height(_sprite) / 2;
	
	draw_sprite_ext(_sprite, 0, xx, yy, 1, 1, 0, c_white, 1)
}

var holdingTempWeapon = tempWeaponSlot.index != WEAPON.fists

if (inventorySize > 0)
{
	// Bright outline for active item
	var xx = rightX - (size * (inventorySize-1 - activeInventorySlot)) - center
	var yy = bottomY - center
	if (holdingTempWeapon) draw_set_alpha(.9)
	draw_rectangle(xx - center, yy - center, xx + center, yy + center, true)
	draw_set_alpha(1)
}

// Temp slot
var tempSlotRightX = rightX - size*inventorySize - size*.5
var tempSlotLeftX = tempSlotRightX - size
var tempSlotAlpha = holdingTempWeapon ? .9 : .7
	
draw_set_color(c_black)
draw_set_alpha(tempSlotAlpha)
draw_rectangle(tempSlotLeftX, bottomY - size, tempSlotRightX, bottomY, false)
draw_set_alpha(1)
draw_set_color(c_white)

var textSize = round(.5 * oController.upscaleMult) / oController.upscaleMult

if (holdingTempWeapon)
{
	draw_sprite_ext(tempWeaponSlot.sprite, 0, tempSlotRightX - center, bottomY - center, 1, 1, 0, c_white, 1)
	draw_rectangle(tempSlotLeftX, bottomY - size, tempSlotRightX, bottomY, true)
	
	if (point_in_rectangle(mouseX, mouseY, tempSlotLeftX, bottomY - size, tempSlotRightX, bottomY))
	{
		showStats = true
		showStatsSlot = -1
	}
}

draw_set_alpha(.9)
draw_text_transformed(tempSlotRightX - center, bottomY+5, "Carry", 1, 1, 0)
draw_set_halign(fa_left)
draw_set_alpha(1)

// Health ----------------------------------------------

var w = 40
var x1 = margin
var y1 = cameraH - margin
var x2 = x1 + w
var y2 = y1 - w

var healthFac = hp / maxHp

//draw_circle()
draw_set_color(c_black)
draw_roundrect(x1, y1, x2, y2, false)
draw_set_color(c_maroon)
draw_roundrect(x1, y1, x2, lerp(y1, y2, healthFac), false)
draw_set_color(c_white)
draw_roundrect(x1, y1, x2, y2, true)
draw_set_color(c_white)

surface_reset_target()

// Weapon stats ----------------------------------------------
if (notInCombat and showStats and inventorySize > 0)
{
	surface_set_target(oController.guiUpscaledSurf)
	
	margin *= oController.upscaleMult
	
	var textScale = round(oController.upscaleMult * .5)
	var textSpacing = 12 * textScale

	var topY = (bottomY - center*2)*oController.upscaleMult
	rightX = cameraW*oController.upscaleMult - margin
	var width = 8 * 20 * textScale
	var leftX = rightX - width
	var centerX = leftX + (rightX-leftX)/2

	var currentWeapon = tempWeaponSlot
	if (showStatsSlot != -1) currentWeapon = weaponInventory[showStatsSlot]
		
	var proj = currentWeapon.projectile
	while (proj.projectileChild != noone) // Check the stats of the last spawned
		proj = proj.projectileChild		  //  projectile, since that's the one usually hitting the enemy

	bottomY = topY-textSpacing

	var weaponStats = [
		$"{currentWeapon.name}",
		$"\"{currentWeapon.description}\"",
		$"Damage: {proj.damage}",
		$"Damage multiplier: {proj.damageMultiplier}x",
		$"Attack speed: {currentWeapon.attackSpeed}/s",
		$"Projectile amount: {currentWeapon.projectileAmount}",
		$"Spread: {currentWeapon.spread} deg",
	]

	var height = textSpacing * (array_length(weaponStats)+1)
	topY = bottomY-height

	draw_set_color(c_black)
	draw_set_alpha(.8)
	draw_rectangle(leftX, bottomY, rightX, topY, false)
	draw_set_color(c_white)

	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_alpha(.9)

	centerX = roundPixelPos(centerX)
	for (var i = 0; i < array_length(weaponStats); i++)
	{
		var yy_ = topY + i*textSpacing + textSpacing
		yy_ = roundPixelPos(yy_)
		draw_text_transformed(centerX, yy_, weaponStats[i], textScale, textScale, 0)
	}

	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_alpha(1)

	surface_reset_target()

}

// --------------------------------------------
}