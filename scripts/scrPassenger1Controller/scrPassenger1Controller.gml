/**
 * @struct	Passenger1Controller()
 * @extends EntityBase
 * @desc Controller for passenger1 npc. Contains variables: [name], methods: [step, draw]
 *
 * @param {Asset.GMObject|Id.Instance} _gameObject - Game object referenced for NPC.
 * @param {String} [_name] [undefined] - Name of the NPC
 */
function Passenger1Controller(
	_gameObject,
	_name = undefined
) : NpcController(_gameObject, _name) constructor {

	with(gameObject) {
		
		// type
		characterClass = CHARACTER_CLASS.NPC;
		characterType = CHARACTER_TYPE.passenger1;
		
		// graphics
		portrait = sNPCPortrait;
		sprite_index = sCharacters;
		characterAnimation = new CharacterAnimation(GetAnimationFramesMsJigglytits);
		anim = characterAnimation.getAnimation;

		// logic
		followingPath = true
		FollowPathInit()
		/*
			0 ... moving
			1 ... stopped
		*/
		moveTimer = irandom_range(180, 600)
		stopTimer = irandom_range(30, 180)
		stuckTimer = 0
		oldPosition = {x: x, y: y}
		tracer = new Tracer()
		moveGraph = new StateGraph(
			0,
			[new State(0), new State(1)],
			[
				new Transition(0, LAMBDA {
					if (moveTimer >= 0) {
						moveTimer--
						return 0
					}
					stopTimer = irandom_range(30, 180)
					return 1
				}),
				new Transition(1, LAMBDA {
					if (stopTimer >= 0) {
						stopTimer--
						return 1
					}
					moveTimer = irandom_range(180, 600)
					return 0
				}),
			]
		)
		destinationGraph = new StateGraph(
			irandom(4),
			[
				new State(0, getLobby().positions.lobby_exit), 
				new State(1, getLobby().positions.info_sign), 
				new State(2, getLobby().positions.terminal), 
				new State(3, getLobby().positions.platform_left), 
				new State(4, getLobby().positions.platform_right)],
			[
				new Transition(0, LAMBDA { return irandom(4) }),
				new Transition(1, LAMBDA { return irandom(4) }),
				new Transition(2, LAMBDA { return irandom(4) }),
				new Transition(3, LAMBDA { return irandom(4) }),
				new Transition(4, LAMBDA { return irandom(4) }),
			]
		)
		debugIf(
			!controller.updatePath(destinationGraph.get().value.x, destinationGraph.get().value.y), //mp_grid_path(getLobby().pfGrid, myPath, x, y, 450, 200, 1),
			"Failed to get path"
		)
	}

	
	step = function() {
		with(gameObject) {
			
			// End path
			if (reachedPathEnd) {
				destinationGraph.next()
				FollowPathInit()
				debugIf(
					!controller.updatePath(destinationGraph.get().value.x, destinationGraph.get().value.y), //mp_grid_path(getLobby().pfGrid, myPath, x, y, 450, 200, 1),
					"Failed to get new path"
				)
				moveTimer = 0
			}
			
			// Check move conditions
			moveGraph.next()
			characterState = (IS_MOVING) ? CharacterState.Run : CharacterState.Idle
			if (IS_MOVING) {
				followPathStep()
				// Is stuck ?
				if (tracer.isStuck()) {//(oldPosition.x == x && oldPosition.y == y) {
					debugIf(stuckTimer > 0, string(name) + " is stuck for " + string(stuckTimer) + " frames")
					stuckTimer++	
				} else {
					stuckTimer = 0	
				}
				// Is stuck
				if (stuckTimer > STUCK_FRAMES_THRESHOLD) {
					debug(name + " stuck too long -> creating new path.")
					destinationGraph.next()
					FollowPathInit()
					var successToFindPath = controller.updatePath(destinationGraph.get().value.x, destinationGraph.get().value.y)
					debugIf(
						!successToFindPath,
						"Failed to get new path"
					)
					if (successToFindPath) stuckTimer = 0
				}
				oldPosition = {x: x, y: y}
				tracer.set(x, y)
			}
		}
	}
	
	draw = function() { 
		with (gameObject) {
			hMove = sign(x - oldPosition.x)
			dir = (hMove != 0) ? sign(hMove) : dir
			if (!is_undefined(myPath) && path_exists(myPath)) followPathDraw()
		}
	}
	
	#macro IS_MOVING moveGraph.get().id == 0
}

function Tracer(
	_threshold = 5,
	_speed = 1,
	_stuckRatio = .1
) constructor {
	oldX = 0
	oldY = 0
	x = 0
	y = 0
	
	indexer = 0
	threshold = _threshold
	distanceThreshold = threshold * _speed * _stuckRatio + 1
	
	static set = function(_x, _y) {
		if (indexer >= threshold) {
			oldX = x
			oldY = y
			x = _x
			y = _y
			indexer = 0
		}
		indexer++
	}
	
	static isStuck = function() {
		return abs(oldX - x) <= distanceThreshold && abs(oldY - y) <= distanceThreshold
	}
}

#macro STUCK_FRAMES_THRESHOLD 60