if (room == rmGame and audio_sound_get_gain(actionMusic) > 0)
	audio_sound_gain(actionMusic, actionMusicRestGain, 2000)
	
if (audio_is_playing(lobbyMusic)) audio_sound_gain(lobbyMusic, 0, 2000)