/**
 * @struct	NpcController
 * @desc Base controller structure for any npc. Contains variables: [name], methods: [step, draw]
 *
 * @param {Asset.GMObject} _gameObject - Game object reference.
 * @param {String} [_name] [undefined] - Name of the NPC
 */
function NpcController(
	_gameObject,
	_name = undefined
) constructor {
    if (!instance_exists(_gameObject))
    {
        name = (!is_undefined(_name)) ? "undefined " + _name : "undefined npc";
        gameObject = undefined;
		warning("Creating base npc controller with undefined gameObject.")
        return self;
    }
	gameObject = _gameObject
    name = (is_undefined(_name)) ? object_get_name(_gameObject.object_index) : _name;
	gameObject.controller = self
	gameObject.name = name

	/**
	 * @function	step()
	 * @desc Step method called in each time the step phase has been triggered.
	 */
	static step = DO NOTHING
	
	/**
	 * @function	draw()
	 * @desc Draw method called in each time when draw phase has been triggered.
	 */
	static draw = DO NOTHING
	
	/**
	 * @function	updatePath()
	 * @desc Updates gameObject's path according to the x/y and target x/y.
	 *
	 * @param {Real} _x - Path target x.
	 * @param {Real} _y - Path target y.
	 * @return Bool - True if path updated, False if update failed.
	 */
	static updatePath = function(
		_x, 
		_y
	) {
		return mp_grid_path(getLobby().pfGrid, gameObject.myPath, gameObject.x, gameObject.y, _x, _y, 1)
	}
	
	gameObject.stepEvent = DO { step() }
	gameObject.drawEvent = DO { draw() }
}
