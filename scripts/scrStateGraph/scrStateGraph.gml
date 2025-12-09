/**
 * @struct	StateGraph
 *
 * @desc Struct which wraps state graph with defined transitions and states.
 * @param 
 */
function StateGraph(_startDestinatinoId, _states, _transitions) constructor {	
	states = _states;
	transitions = _transitions;
	startDestinationId = _startDestinatinoId
	
	currentState = firstOrNull(
		states, 
		function(elem) { return elem.id == startDestinationId }
	);
	
	if (is_undefined(currentState)) error("StateGraph(): invalid states ids or start id!")
	
	static next = function() {
		var transition = firstOrNull(transitions, function(elem) {
			return elem.stateId == currentState.id;
		});
		if (is_undefined(transition)) {
			info("StateGraph.next(): invalid next id of state!")
			return currentState
		}
		
		nextStateId = transition.getNextState();
		var nextState = firstOrNull(states, function(elem) { return elem.id == nextStateId });
		if (is_undefined(nextState)) {
			info("StateGraph.next(): invalid next id of state!")
		} else {
			currentState = nextState;
		}
		
		return currentState;
	}
	
	static get = function() {
		return currentState;
	}
}

/**
 * @struct	BaseTransition
 */
function BaseTransition() constructor {
	startDestinationId = undefined
	getNextState = function() { return undefined }
}

/**
 * @struct	Transition
 */
function Transition(_stateId, _getNextState = function() { return pointer_null }) : BaseTransition() constructor {
	self.stateId = _stateId
	self.getNextState = _getNextState
}

/**
 * @struct	StateTransition
 */
function StateTransition(_stateId, _transitionState, _getNextState = function() { return pointer_null }) : BaseTransition() constructor {
	self.stateId = _stateId
	self.conditionState = _transitionState
	self.getNextState = _getNextState
}

/**
 * @struct	State
 */
function State(_id, _value = undefined) constructor {
	self.id = _id
	self.value = _value
}
