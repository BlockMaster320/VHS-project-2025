// Default = Player
function GetAnimationFramesDefault(characterState) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: [0,3], speeds: [.08, .08, .08, .08]}
	    case CharacterState.Run:  return {range: [4,9], speeds: [.3, .3, .15, .3, .3, .3]}
	    case CharacterState.Harm: return {range: [0,0], speeds: [.1]}
	    case CharacterState.Dead: return {range: [0,0], speeds: [.1]}
	};
}

// Mechanic
function GetAnimationFramesMechanic(characterState, _offset = 66) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: GetAnimationRange(_offset, characterState), speeds: [.08, .08, .08, .08]}
	    case CharacterState.Run:  return {range: GetAnimationRange(_offset, characterState), speeds: [.3, .3, .15, .3, .3, .3]}
	    case CharacterState.Harm: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	    case CharacterState.Dead: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	};
}

// Red NPC
function GetAnimationFramesLatin(characterState, _offset = 22) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: GetAnimationRange(_offset, characterState), speeds: [.08, .08, .08, .08]}
	    case CharacterState.Run:  return {range: GetAnimationRange(_offset, characterState), speeds: [.3, .3, .15, .3, .3, .3]}
	    case CharacterState.Harm: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	    case CharacterState.Dead: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	};
}

// Purple player
function GetAnimationFramesCompanion(characterState, _offset = 55) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: GetAnimationRange(_offset, characterState), speeds: [.08, .08, .08, .08]}
	    case CharacterState.Run:  return {range: GetAnimationRange(_offset, characterState), speeds: [.3, .3, .15, .3, .3, .3]}
	    case CharacterState.Harm: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	    case CharacterState.Dead: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	};
}

// Pink NPC
function GetAnimationFramesMsJigglytits(characterState, _offset = 11) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: GetAnimationRange(_offset, characterState), speeds: [.08, .08, .08, .08]}
	    case CharacterState.Run:  return {range: GetAnimationRange(_offset, characterState), speeds: [.3, .3, .15, .3, .3, .1]}
	    case CharacterState.Harm: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	    case CharacterState.Dead: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	};
}

// Cleaner 1 NPC
function GetAnimationFramesCleaner1(characterState, _offset = 33) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: GetAnimationRange(_offset, characterState), speeds: [.08, .08, .08, .08]}
	    case CharacterState.Run:  return {range: GetAnimationRange(_offset, characterState), speeds: [.3, .3, .15, .3, .3, .1]}
	    case CharacterState.Harm: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	    case CharacterState.Dead: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	};
}

// Cleaner 2 NPC
function GetAnimationFramesCleaner2(characterState, _offset = 44) {
	switch(characterState) {
	    case CharacterState.Idle: return {range: GetAnimationRange(_offset, characterState), speeds: [.08, .08, .08, .08]}
	    case CharacterState.Run:  return {range: GetAnimationRange(_offset, characterState), speeds: [.3, .3, .15, .3, .3, .1]}
	    case CharacterState.Harm: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	    case CharacterState.Dead: return {range: GetAnimationRange(_offset, characterState), speeds: [.1]}
	};
}

// Player
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
