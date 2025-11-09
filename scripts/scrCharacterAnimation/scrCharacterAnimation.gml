function GetAnimationFrameRange(characterState) {
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