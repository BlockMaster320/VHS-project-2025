// DEBUG TELEPORT
if (room = rmDebug)
{
	if (mouse_check_button(mb_right))
	{
		var off = 8
		draw_line(mouse_x-off,mouse_y,mouse_x+off,mouse_y)
		draw_line(mouse_x,mouse_y-off,mouse_x,mouse_y+off)
		draw_circle(mouse_x, mouse_y, 5, true)
	}
	if (mouse_check_button_released(mb_right))
	{
		oPlayer.x = mouse_x
		oPlayer.y = mouse_y
	}
}

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
if (activeWeapon != -1 and
	( (activeWeapon.projectile.projType == PROJECTILE_TYPE.ranged and activeWeapon.reloading) or
	  (activeWeapon.projectile.projType == PROJECTILE_TYPE.melee and activeWeapon.primaryActionCooldown >= 0)
	))
{
	var w = .1
	var yOff = 13

	var left = x - 10
	var right = x + 10
	var top = y + yOff
	var bott = y + yOff + w

	draw_rectangle(left, top, right, bott, false)

	var reloadFac = activeWeapon.primaryActionCooldown / (60 / activeWeapon.attackSpeed)
	if (activeWeapon.projectile.projType == PROJECTILE_TYPE.ranged)
		reloadFac = 1 - (activeWeapon.reloadProgress / (activeWeapon.reloadTime * 60))
	var sliderX = lerp(right, left, reloadFac)
	var h = 4
	
	draw_rectangle(sliderX - w/2, top - h/2, sliderX + w/2, bott + h/2, false)
}


if (global.inputState != INPUT_STATE.dialogue)
{
// UI -----------------------------------

surface_set_target(oController.guiSurf)

var margin = 2 * TILE_SIZE
var rightX = cameraW - margin
var bottomY = cameraH - margin

// Inventory

var size = 1.6 * TILE_SIZE
var center = size/2

draw_set_color(c_black)
draw_set_alpha(.9)

draw_rectangle(rightX - size*inventorySize, bottomY - size, rightX, bottomY + 1., false)

draw_set_alpha(1)
draw_set_color(c_white)

for (var i = 0; i < inventorySize; i++)
{
	var xx = rightX - (size * (inventorySize-1 - i)) - center
	var yy = bottomY - center
	
	if (weaponInventory[i].durabilityMult != 0)
	{
		var weaponDurFac = weaponInventory[i].remainingDurability / 1
		draw_set_alpha(.8)
		draw_rectangle(xx - center, yy - center, lerp(xx-center, xx+center, weaponDurFac), yy + center + 1., false)
		draw_set_alpha(1)
	}
	
	draw_sprite_ext(weaponInventory[i].sprite, 0, xx, yy, 1, 1, 0, c_white, 1)
}

var xx = rightX - (size * (inventorySize-1 - activeInventorySlot)) - center
var yy = bottomY - center
draw_rectangle(xx - center, yy - center, xx + center, yy + center, true)

// Health

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

// Weapon stats
if (showStats)
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

	var currentWeapon = weaponInventory[activeInventorySlot]

	bottomY = topY-textSpacing

	var weaponStats = [
		$"Damage: {currentWeapon.projectile.damage}",
		$"Damage multiplier: {currentWeapon.projectile.damageMultiplier}x",
		$"Attack speed: {currentWeapon.attackSpeed}/s",
		$"Spread: {currentWeapon.spread} deg",
		$"Projectile amount: {currentWeapon.projectileAmount}",
		$"Knockback: {currentWeapon.projectile.targetKnockback}",
		$"Movement speed: {oPlayer.walkSpdDef}",
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