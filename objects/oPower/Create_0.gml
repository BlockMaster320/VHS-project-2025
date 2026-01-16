// Inherit the parent event
event_inherited();

drawSelf = false;
imageIndex = 0;

interactionFunction = function() {
	with (oDoorEscalator) {
		image_index = sprite_get_number(sDoorFront) - 1;
		with (oEscalatorBarrier) instance_destroy(self);
	}
}