//var dt = delta_time / 1000000 * 60

#region Walking

var walkDir = point_direction(0, 0, oController.right - oController.left, oController.down - oController.up)
whsp = lengthdir_x(walkSpd * global.gameSpeed, walkDir) * sign(oController.right + oController.left)
wvsp = lengthdir_y(walkSpd * global.gameSpeed, walkDir) * sign(oController.down + oController.up)

#endregion


#region Evaluate collisions and position

// Evaluate momentum
hsp = whsp
vsp = wvsp

if (y < 120) room_goto(rmGame)

/// Tilemap collisions

// Horizontal
if (place_meeting(x + hsp, y, global.tilemapCollision))
{
	while (!place_meeting(x + sign(hsp), y, global.tilemapCollision)) x += sign(hsp)
	x = round(x)
	hsp = 0;
}
x += hsp


// Vertical
if (place_meeting(x, y + vsp, global.tilemapCollision))
{
	while (!place_meeting(x, y + sign(vsp), global.tilemapCollision)) y += sign(vsp)
	y = round(y)
	vsp = 0;
}
y += vsp

#endregion


#region Weapon Inventory

// Swap active weapon
if (oController.swapSlot or oController.scrollSlot != 0)
{
	weaponInventory[activeWeaponSlot].active = false
	activeWeaponSlot = !activeWeaponSlot
	weaponInventory[activeWeaponSlot].active = true
}

// Update weapons
for (var i = 0; i < INVENTORY_SIZE; i++)
	weaponInventory[i].update()

#endregion


// Debug
if (keyboard_check(ord("R"))) game_restart()

playerController.step()
