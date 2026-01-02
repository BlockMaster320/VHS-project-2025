function GetAnimationFramesDefault(characterState) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: [0,3], speeds: [.05, .12, .05, .12]}
	    case CharacterState.Run:  return {range: [4,9], speeds: [.1]}
	    case CharacterState.Harm: return {range: [0,0], speeds: [.1]}
	    case CharacterState.Dead: return {range: [0,0], speeds: [.1]}
	};
}

function GetAnimationFrameMechanic(characterState, _offset = 66) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: GetAnimationRange(_offset, characterState), speeds: [.08, .08, .08, .08]}
	    case CharacterState.Run:  return {range: GetAnimationRange(_offset, characterState), speeds: [.3, .3, .15, .3, .3, .3]}
	    case CharacterState.Harm: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	    case CharacterState.Dead: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	};
}

function GetAnimationFramesMsJigglytits(characterState, _offset = 11) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: GetAnimationRange(_offset, characterState), speeds: [.08, .08, .08, .08]}
	    case CharacterState.Run:  return {range: GetAnimationRange(_offset, characterState), speeds: [.3, .3, .15, .3, .3, .1]}
	    case CharacterState.Harm: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	    case CharacterState.Dead: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	};
}

function GetAnimationFramesPlayer(characterState, _offset = 0) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: GetAnimationRange(_offset, characterState), speeds: [.08, .08, .08, .08]}
		case CharacterState.Run:  return {range: GetAnimationRange(_offset, characterState), speeds: [.3, .3, .15, .3, .3, .3]}
	    case CharacterState.Harm: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	    case CharacterState.Dead: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	};
}

function GetAnimationFramesHands(characterState) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: [0,3], speeds: [.08, .08, .08, .08]}
		case CharacterState.Run:  return {range: [4,13], speeds: [.15, .3, .3, .3, .15, .15, .3, .3, .3, .15]}
	    case CharacterState.Harm: return {range: [0,0], speeds: [.1]}
	    case CharacterState.Dead: return {range: [0,0], speeds: [.1]}
	};
}


#macro ANIM_IDLE_LEN 3
#macro ANIM_RUN_LEN 5
function GetAnimationRange(_offset, _characterState) {
	var runOffset = _offset + ANIM_IDLE_LEN + 1
	var deadOffset = runOffset + ANIM_RUN_LEN + 1
	switch(_characterState) {
	    case CharacterState.Idle: return [_offset, _offset + ANIM_IDLE_LEN]
		case CharacterState.Run: return [runOffset, runOffset + ANIM_RUN_LEN]
	    case CharacterState.Harm: return [0,0]
	    case CharacterState.Dead: return [deadOffset, deadOffset]
	};
}

function CharacterAnimation(_getAnimation, _startCharacterState = undefined) constructor {
	getAnimation			= _getAnimation
	startCharacterState		= is_undefined(_startCharacterState) ? CharacterState.Idle : _startCharacterState;
}
