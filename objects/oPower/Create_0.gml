// Inherit the parent event
event_inherited();

drawSelf = false;
imageIndex = 0;

global.powerOn = false

interactionFunction = function() {
	with (oDoorEscalator) {
		image_index = sprite_get_number(sDoorFront) - 1;
		with (oEscalatorBarrier) instance_destroy(self);
	}
	
	audio_play_sound(sndPowerOn, 0, false)
	oCamera.currentShakeAmount += 10
	global.powerOn = true
}

sound = audio_play_sound(sndPowerBuzz, 0, true, 0)