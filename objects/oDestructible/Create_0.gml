// Destroys the object if the given object is colliding with it has a chance of dropping a weapon
function DestroyOnContact(_obj) {
	if (_obj == noone) return;
	if (distance_to_object(_obj) > 50) return;
	
	if (place_meeting(x, y, _obj)) {
		part_particles_create(oController.destructibleParticlesSys, random_range(x-12,x+12), random_range(y-15, y+15), oController.destructibleParticles, 8)
		var _sound = choose(sndCrateDestruction1, sndCrateDestruction2, sndCrateDestruction3);
		audio_play_sound(_sound, 0, false);
		instance_destroy(self);
	}
}

// Inherit the parent event
event_inherited();

