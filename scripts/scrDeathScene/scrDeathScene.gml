function DeathScene(_deadCharacter) {
	with(_deadCharacter) {
		 xx = x
		 yy = y
		
		alpha = 0
		weaponAlpha = 0
		handsAlpha = 0

		// this code spawns NPC
		cleaner = instance_create_layer(xx + 32, yy, "Instances", oNPC)
		player = instance_create_layer(xx, yy, "Instances", oNPC)
	
		
		with(cleaner) { 
			var middlePositionCleaner = x - 32
			var endPositionCleaner = x - 2 * 32
			
			alpha = 0
	
			controller = new PlayerCleanerController(id, "Cleaner", true)

			dir = -1;
			characterState = CharacterState.Run
			
			toAnimation = function(_animationState) {
				characterState = _animationState
			}
			toPlayer = new TweenProperty(middlePositionCleaner, function() { return x }, function(_x) { x = _x }, 800)
			withPlayer = new TweenProperty(endPositionCleaner, function() { return x }, function(_x) { x = _x }, 800)
			
			showCharacter = new TweenProperty(1, function() { return alpha }, function(_x) { alpha = _x }, 800, global.Ease.EaseOutExpo)
			hideCharacter = new TweenProperty(0, function() { return alpha }, function(_x) { alpha = _x }, 800, global.Ease.EaseInExpo)
		}
	
		with(player) {
			characterCreate(CHARACTER_TYPE.dummyPlayer)
		
			var endPositionCleanerGrabbed = x - 32
			characterState = CharacterState.Dead
			grabbed =  new TweenProperty(endPositionCleanerGrabbed, function() { return x }, function(_x) { x = _x }, 800)
			
			hideCharacter = new TweenProperty(0, function() { return alpha }, function(_x) { alpha = _x }, 800, global.Ease.EaseInExpo)
		}
	
		global.inputState = INPUT_STATE.cutscene
		new TweenSequence([
			new TweenAction(function() {
				audio_sound_gain(oController.actionMusic, 0, 0)
				audio_sound_gain(oController.subwayAmbiance, 0, 0)
			}),
			// start cinema borders
			getCinemaBorders().Set(CinemaBordersState.CINEMA).GetTween(),
			TweenWait(500),
			// animate cleaner to playerF
			new TweenAction(function() {
				cleaner.showCharacter.start()
			}),
			cleaner.toPlayer,
			// Grap player & drag to left
			new TweenAction(function() {
				new TweenSequence([
					TweenWait(200),
					player.grabbed
				]).start()
				
				cleaner.hideCharacter.start()
				player.hideCharacter.start()
			}),
			cleaner.withPlayer,
			// hide scene
			getCinemaBorders().Set(CinemaBordersState.WHOLE).GetTween(),
			// move to new scene
			new TweenAction(function() {
				room_goto(rmLobby);
				alpha = 1
				weaponAlpha = 1
				handsAlpha = 1
				InitPlayerStats()
				// Reset player buffs
				// Init player weapons
			}),
			// lobby & dialog
			new TweenAction(function() {
				inLobbyCleaner = instance_create_layer(oPlayer.x + 32, oPlayer.y, "Instances", oNPC)
				with(inLobbyCleaner) { 
					controller = new PlayerCleanerController(id, "Cleaner", false)
					dir = -1
				}
				getCinemaBorders().Set(CinemaBordersState.NONE, DO {
					oDialogues.startDialogue(
						CHARACTER_TYPE.playerCleaner, 
						function() { 
							debug("Calling controller.goTotheDungeon() for cleaner npc...")
							inLobbyCleaner.controller.goToTheDungeon()
						}
					) 	
				}).Start()
			})
			// TODO: Cleaner will disappear - exit after dialogue ends

		]).start()
	}
}
