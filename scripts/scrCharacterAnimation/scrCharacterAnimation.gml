function GetAnimationFramesDefault(characterState) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: [0,3], speeds: [.03, .16, .03, .16]}
	    case CharacterState.Run:  return {range: [0,0], speeds: [.1]}
	    case CharacterState.Harm: return {range: [0,0], speeds: [.1]}
	    case CharacterState.Dead: return {range: [0,0], speeds: [.1]}
	};
}

function CharacterAnimation(_getAnimation, _startCharacterState = undefined) constructor {
	getAnimation			= _getAnimation
	startCharacterState		= is_undefined(_startCharacterState) ? CharacterState.Idle : _startCharacterState;
}