// Generic attributes ------------------------

walkSpd = 2

// Generic constants -------------------------

frictionMult = .7


// Momentum ----------------------------------

whsp = 0	// Horizontal walking speed
wvsp = 0	// Vertical walking speed

mhsp = 0	// Momentum speed
mvsp = 0	// Used for example for knockback

hsp = 0		// Total horizontal speed
vsp = 0		// Total horizontal speed


// Combat ------------------------------------

hp = 150
effects = []

// Other
characterType = noone;
characterClass = noone;
name = "";
portrait = sNPCPortrait;
harmed_duration = 0;
dir = 1;

characterState = CharacterState.Idle;
	
// animation control
characterAnimation = noone;
anim = noone;
sprite_index = sCharacters;
sprite_frame = 0;
image_speed = 0.1;
	
// Event functions
stepEvent = noone;
drawEvent = noone;
