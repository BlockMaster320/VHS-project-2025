// Get generic attributes
event_inherited()
characterCreate(CHARACTER_TYPE.player);

// Player attributes ------------------------

function InitPlayerStats()
{
	walkSpdDef = 1.7 //7
	walkSpdSprint = 2.8	// Use when running between cleared rooms
	walkSpd = walkSpdDef
	maxHp = 150
	
	inventorySize = 2
	hp = maxHp
	characterState = CharacterState.Idle
	
	// Buff specific
	global.gameSpeed = oController.defaultGameSpeed
	dualWield = false
	buffApplyAmount = 1

}
InitPlayerStats()	// Do this, so we can reset player stats to default later

hp = maxHp

// Inventory --------------------------

activeInventorySlot = 0
//activeSlotSwapCooldown = new Cooldown(30)	// In frames
notInCombat = true
showStats = true

// Weapons
function InitPlayerWeapons()
{
	weaponInventory = array_create(inventorySize, noone)
	for (var i = 0; i < inventorySize; i++)
	{
		weaponInventory[i] = acquireWeapon(WEAPON.fists, id, i==activeInventorySlot) // Fists
		weaponInventory[i].playerInventorySlot = i
	}
	tempWeaponSlot = acquireWeapon(WEAPON.fists, id, false) // For one time use weapons
}
InitPlayerWeapons()

ignoreInputBuffer = new Cooldown(60)	// To prevent the player from shooting right away

// Buffs
buffs = []

function ResetPlayerBuffs()
{
	buffs = []
	EvaluatePlayerBuffs()	// Order is important!
	EvaluateWeaponBuffs()
	EvaluateOneTimeUseBuffs()
}

function ResetPlayer()
{
	ResetPlayerBuffs()
	InitPlayerWeapons()
	InitPlayerStats()	// Keep this line, it is not redundant (for some reason)
}