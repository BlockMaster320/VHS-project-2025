/**
 * @struct	StateGraph
 *
 * @desc Struct which wraps state graph with defined transitions and states.
 * @param {Any} _startDestinationId - Id of current state.
 * @param {Array<Struct.State>} _states - List of all states present in this state graph. State contains id.
 * @param {Array<Struct.BaseTransition>} _transitions - List of transitions defined by inheriting from BaseTransition. Has stateId and getNextState function.
 */
function StateGraph(_startDestinationId, _states, _transitions) constructor {	
	states = _states;
	transitions = _transitions;
	startDestinationId = _startDestinationId
	
	currentState = firstOrNull(
		states, 
		function(elem) { return elem.id == startDestinationId }
	);
	
	if (is_undefined(currentState)) error("StateGraph(): invalid states ids or start id!")
	
	static next = function() {
		var transition = firstOrNull(transitions, function(elem) {
			return elem.id == currentState.id;
		});
		if (is_undefined(transition)) {
			info("StateGraph.next(): invalid next id of state! ID = " + string(nextStateId))
			return currentState
		}
		
		nextStateId = transition.getNextState();
		var nextState = firstOrNull(states, function(elem) { return elem.id == nextStateId });
		if (is_undefined(nextState)) {
			info("StateGraph.next(): invalid next id of state! ID = " + string(nextStateId))
		} else {
			currentState = nextState;
		}
		
		return currentState;
	}
	
	static get = function() {
		return currentState;
	}
	
	static set = function(_stateId) {
		stateId = _stateId
		var newState = firstOrNull(
			states, 
			function(elem) { 
				return elem.id == stateId
			}
		);
		currentState = (is_undefined(newState)) ? currentState : newState
	}
}

/**
 * @struct	BaseTransition
 */
function BaseTransition() constructor {
	id = undefined
	getNextState = function() { return undefined }
}

/**
 * @struct	Transition
 */
function Transition(_stateId, _getNextState = function() { return pointer_null }) : BaseTransition() constructor {
	self.id = _stateId
	self.getNextState = _getNextState
}

/**
 * @struct	StateTransition
 */
function StateTransition(_stateId, _transitionState, _getNextState = function() { return pointer_null }) : BaseTransition() constructor {
	self.id = _stateId
	self.state = _transitionState
	self.getNextState = _getNextState
}

/**
 * @struct	State
 */
function State(_id, _value = undefined) constructor {
	self.id = _id
	self.value = _value
}
