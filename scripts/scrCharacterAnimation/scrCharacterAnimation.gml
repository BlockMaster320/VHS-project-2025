function DefaultAnimation(characterState) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: [0,1]}
	    case CharacterState.Run:  return {range: [1,3]}
	    case CharacterState.Harm: return {range: [4,4]}
	    case CharacterState.Dead: return {range: [5,5]}
	};
}

function EnemyAnimation(characterState) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: [0,4]}
	    case CharacterState.Run:  return {range: [0,4]}
	    case CharacterState.Harm: return {range: [4,4]}
	    case CharacterState.Dead: return {range: [5,5]}
	};
}

function PlayerAnimation(characterState) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: [0,1]}
	    case CharacterState.Run:  return {range: [1,3]}
	    case CharacterState.Harm: return {range: [4,4]}
	    case CharacterState.Dead: return {range: [5,5]}
	};
}

function CharacterAnimation(_getAnimation, _startCharacterState = undefined) constructor {
	getAnimation			= _getAnimation
	startCharacterState		= is_undefined(_startCharacterState) ? CharacterState.Idle : _startCharacterState;
}