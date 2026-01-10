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
	_name = undefined
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
			1,
			[new State(0), new State(1)],
			[
				new Transition(0, LAMBDA { return 0 }),
				new Transition(1, LAMBDA { return 1 }),
			]
		)
	}
		
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
		with(gameObject) {
			// End path
			if (reachedPathEnd) {
				// something at the end of the path
			}
			
			// Check move conditions
			characterState = (IS_MOVING) ? CharacterState.Run : CharacterState.Idle
			if (IS_MOVING) {
				followPathStep()
			}
			
			hMove = sign(x - oldPosition.x)
			dir = (hMove != 0) ? sign(hMove) : dir
		}
	}
	
	draw = function() {
		with(gameObject) {
			if (!is_undefined(myPath) && path_exists(myPath)) followPathDraw()
		}
	}
	
	#macro IS_MOVING moveGraph.get().id == 0
}