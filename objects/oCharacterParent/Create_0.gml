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

maxHp = 150
hp = maxHp
effects = []

// Hit flash
hitFlashCooldown = new Cooldown(10)
hitFlashCooldown.value = 0
flashFacLoc = shader_get_uniform(shHitFlash, "flashFac")
flashFac = 0
flashFacMixFac = .5
function hitFlash()
{
	hitFlashCooldown.reset()
	flashFac = 0
}


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
inRange = false

// animation control
characterAnimation = noone;
anim = noone;
sprite_index = noone;
sprite_frame = 0;
image_speed = 0.1;
depth = -y;
alpha = 1
weaponAlpha = 1
	
// Event functions
stepEvent = noone
drawEvent = noone
onDeathEvent = function(){ instance_destroy() }


// Dialogues
inRange = false