// Generic attributes ------------------------

walkSpd = 1

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


// Character attributes ----------------------------------
// These are assigned by calling characterCreate()

characterType = noone;
characterClass = noone;
name = "";
portrait = sNPCPortrait;
myWeapon = noone	// Non-player only
harmed_duration = 0;
dir = 1;

characterState = CharacterState.Idle;
	
// animation control
characterAnimation = noone;
anim = noone;
sprite_index = noone;
sprite_frame = 0;
image_speed = 0.1;
depth = -y;
	
// Event functions
stepEvent = noone
drawEvent = noone
onDeathEvent = function(){ instance_destroy() }
