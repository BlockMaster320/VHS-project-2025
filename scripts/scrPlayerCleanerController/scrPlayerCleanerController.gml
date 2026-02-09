/**
 * @struct	PlaerCleanerController()
 * @extends NpcController
 * @desc Controller for passenger1 npc. Contains variables: [name], methods: [step, draw]
 *
 * @param {Asset.GMObject|Id.Instance} _gameObject - Game object referenced for NPC.
 * @param {String} [_name] [undefined] - Name of the NPC
 */
function PlayerCleanerController(
	_gameObject,
	_name = undefined,
	_isStatic = false,
) : NpcController(_gameObject, _name) constructor {
	with(gameObject) {
		// Info
		characterClass = CHARACTER_CLASS.NPC;
		characterType = CHARACTER_TYPE.playerCleaner;
		
		// Dialog
		name = "Player cleaner";
		portrait = sStudentPortrait;
			
		// Graphics
		drawnSprite = sCharacters;
		imageOffset = 44;
		characterAnimation = new CharacterAnimation(GetAnimationFramesCleaner2);
		anim = characterAnimation.getAnimation;
		
		// Movement
		FollowPathInit()
		oldPosition = {x: x, y: y}
		moveGraph = new StateGraph(
			CharacterState.Idle,
			[new State(CharacterState.Run), new State(CharacterState.Idle)],
			[
				new Transition(CharacterState.Run, LAMBDA { return CharacterState.Run }),
				new Transition(CharacterState.Idle, LAMBDA { return CharacterState.Idle }),
			]
		)
		
		// Lobby
		dungeonEntryIntroY = getLobby().positions.dungeon_entry.y + 20
		dungeonEntryOutroY = getLobby().positions.dungeon_entry.y
	}
	isStataic = _isStatic
		
	/// @function	goToTheDungeon()
	/// @desc Method which triggers clenaer npc to run to the exit of the lobby.
	goToTheDungeon = function() {
		debug("goToTheDungeon called")
		with(gameObject) {
			moveGraph.set(1)
			debug("MOVEGRAPH = " + string(moveGraph.get().id))
			//FollowPathInit()
			var dungeonEnterPosition = getLobby().positions.dungeon_entry
			var successToFindPath = controller.updatePath(dungeonEnterPosition.x, dungeonEnterPosition.y)
			if (!successToFindPath) {
				debug("Failed to get new path for NPC: " + string(name))
				new TweenProperty(
					x + 64, 
					function() {return x},
					function(_value) {x = _value},
					2000,
				).start()
				new TweenProperty(
					0, 
					function() {return alpha},
					function(_value) {alpha = _value},
					2000,
					global.Ease.EaseInCubic
				).start()
			}
			
		}
	}
	
	step = function() {
		if (!isStataic) {
			with(gameObject) {
				// End path
				if (variable_instance_exists(self, "reachedPathEnd") && reachedPathEnd) {
					// something at the end of the path
				}
			
				// Check move conditions
				characterState = moveGraph.get().id
				if (moveGraph.get().id == CharacterState.Run) {
					followPathStep()
				}
			}
		}
		with(gameObject) {
			hMove = sign(x - oldPosition.x)
			dir = (hMove != 0) ? sign(hMove) : dir
			
			oldPosition = {x: x, y: y}
			
			if (reachedPathEnd) {
				new TweenProperty(
					0, 
					function() {return alpha},
					function(_value) {alpha = _value},
					500,
					global.Ease.Linear,
					DO { instance_destroy(self)	}
				).start()
			}
		}
	}
	
	draw = function() {
		if (!isStataic) {
			with(gameObject) {
				if (variable_instance_exists(self, "myPath") && !is_undefined(myPath) && path_exists(myPath)) followPathDraw()
			}
		}
		if (global.AI_DEBUG) debugDraw([string(gameObject.moveGraph.get().id)])
	}
}