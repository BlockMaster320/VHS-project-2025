containsWeapon = random(1) < DESTRUCTIBLE_WEAPON_CHANCE
if (room == rmLobby) containsWeapon = false
randomOffset = random(100)

// Destroys the object if the given object is colliding with it has a chance of dropping a weapon
function DestroyOnContact(_obj) {
	if (_obj == noone) return;
	//if (distance_to_object(_obj) > 50) return;	// This is an anti-optimization
	//if (point_distance(x, y, _obj.x, _obj.y) > 50) return;
	
	if (place_meeting(x, y, _obj)) {
		
		var objDir = 0
		if (_obj.object_index == oProjectile)
			objDir = _obj.dir
		else
			objDir = point_direction(_obj.xprevious, _obj.yprevious, _obj.x, _obj.y)
		
		var dirRange = 30
		part_type_direction(oController.destructibleParticles, objDir-dirRange, objDir+dirRange, 0, 0)
		part_particles_create(oController.destructibleParticlesSys, random_range(x-12,x+12), random_range(y-15, y+15), oController.destructibleParticles, 8)
		
		var _sound = choose(sndCrateDestruction1, sndCrateDestruction2, sndCrateDestruction3);
		var pitch = random_range(.8, 1.3)
		audio_play_sound(_sound, 0, false, 1, 0, pitch);
		
		if (containsWeapon) {
			var _weaponID = choose(WEAPON.crowbar, WEAPON.groanTube, WEAPON.paperPlane, WEAPON.fan, WEAPON.rat)
			var _weapon = instance_create_layer(x, y, "Instances", oWeaponPickup);
			_weapon.setupWeaponPickup(_weaponID);
		}
		
		instance_destroy(self);
	}
}

// Inherit the parent event
event_inherited();

