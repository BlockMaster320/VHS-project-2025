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
		portrait = sNPCPortrait;
			
		// Graphics
		sprite_index = sCharacters;
		characterAnimation = new CharacterAnimation(GetAnimationFramesCleaner1);
		anim = characterAnimation.getAnimation;
		
		// Movement
		oldPosition = {x: x, y: y}
		moveGraph = new StateGraph(
			CharacterState.Idle,
			[new State(CharacterState.Run), new State(CharacterState.Idle)],
			[
				new Transition(CharacterState.Run, LAMBDA { return CharacterState.Run }),
				new Transition(CharacterState.Idle, LAMBDA { return CharacterState.Idle }),
			]
		)
	}
	isStataic = _isStatic
		
	/// @function	goToTheDungeon()
	/// @desc Method which triggers clenaer npc to run to the exit of the lobby.
	goToTheDungeon = function() {
		with(gameObject) {
			moveGraph.set(0)
			FollowPathInit()
			var successToFindPath = controller.updatePath(getLobby().positions.dungeon_entry.x, getLobby().positions.dungeon_entry.y)
			debugIf(
				!successToFindPath,
				"Failed to get new path"
			)
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
		}
	}
	
	draw = function() {
		if (!isStataic) {
			with(gameObject) {
				if (variable_instance_exists(self, "myPath") && !is_undefined(myPath) && path_exists(myPath)) followPathDraw()
			}
		}
	}
}