function ShopkeeperScene() {
	var _shopkeeper = noone;
	with (oPlayer) {
		_shopkeeper = instance_nearest(x, y, oNPC);
	}
	
	with(_shopkeeper) {
		
		audio_play_sound(sndHeartbrake, 0, false)
	
		var _endPos = y - 32
		move = new TweenProperty(_endPos, function() { return y }, function(_y) { y = _y }, 1500)
		moveBack = new TweenProperty(y, function() { return y }, function(_y) { y = _y }, 100)
	
		global.inputState = INPUT_STATE.cutscene
		new TweenSequence([
			new TweenAction(function() {
				global.inputState = INPUT_STATE.cutscene
				audio_sound_gain(oController.actionMusic, 0, 0)
				audio_sound_gain(oController.subwayAmbiance, 0, 0)
			}),
			
			// start cinema borders
			getCinemaBorders().Set(CinemaBordersState.CINEMA).GetTween(),
			new TweenAction(function() {
				new TweenSequence([
					TweenWait(200),
					move
				]).start()
			}),
			
			TweenWait(1800),

			new TweenAction(function() {
				new TweenSequence([
					getCinemaBorders().SetInstantly(CinemaBordersState.WHOLE).GetTween(),
					TweenWait(200),
					moveBack
				]).start()
				
				audio_play_sound(sndSlap, 0, false);
				audio_play_sound(sndHit_001, 0, false);
				DealDamage(oPlayer, 25);
			}),
			
			TweenWait(500),

			new TweenAction(function() {
				getCinemaBorders().Set(CinemaBordersState.NONE).Start()
				global.inputState = INPUT_STATE.playing
				oCamera.currentShakeAmount += 50;
			}),
		

		]).start()
	}
}
