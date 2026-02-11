Constants()

// Floor state ----------------------------
currentFloor = 0;

roomsCleared = 0
buffsObtained = 0
// -----------------------------------------

//gameFPS = display_get_frequency()
gameFPS = 60
//gameFPS = 500
//game_set_speed(gameFPS, gamespeed_fps)	// Experimental
defaultGameSpeed = 60 / gameFPS
global.gameSpeed = defaultGameSpeed

window_set_cursor(cr_cross)
//window_set_cursor(cr_none)
//cursor_sprite = sCursor
display_set_timing_method(tm_sleep)		// Turn off vsync

global.inputState = INPUT_STATE.playing


WeaponsInit()
buffRarityIndexes = [BUFF.commonIndex, BUFF.rareIndex]

// Intro
introTextAlpha = 0

//if (debug_mode)
//	show_debug_overlay(true)

draw_set_font(fntGeneric)

// Custom alarm system
alarms = []	// Array of "Alarm" structs

// Procedural pathfinding
wallGrid = undefined
pfGrid = undefined

// Lighting -------------------------------------
lightSurface = -1
draw_set_circle_precision(32)
texelSizeLoc = shader_get_uniform(shLightFilter, "texSize")
lightTexW = -1
lightTexH = -1
timeLocLight = shader_get_uniform(shLightFilter, "time")
safetyMargin = 10
//timeLocShadow = shader_get_uniform(shShadowFilter, "time")

// Pixel art upscaling --------------------------------
application_surface_draw_enable(false)
upscaleMult = 4
windowWidthPrev = window_get_width()
windowHeightPrev = window_get_height()
guiSurf = surface_create(cameraW, cameraH)
guiUpscaledSurf = -1
updateUpscaleFactor()
surfaceDrawPositionX = 0
surfaceDrawPositionY = 0
fullscreenPrev = window_get_fullscreen()
appWindowXprev = window_get_x()
appWindowYprev = window_get_y()

// Sound ----------------------------------------------

// Music
#macro actionMusicFightGain 1
#macro actionMusicRestGain .4
actionMusic = audio_play_sound(sndActionMusic, 0, true, 0)
audio_pause_sound(actionMusic)
lobbyMusic = audio_play_sound(sndLobbyMusic, 0, true, 0)
audio_pause_sound(lobbyMusic)
gameOverMusic = audio_play_sound(sndGameOver, 0, false, 0)
audio_stop_sound(gameOverMusic)

// Ambiance
openingAmbiance = audio_play_sound(sndOpeningAmbiance, 0, true)
audio_pause_sound(openingAmbiance)
subwayAmbiance = audio_play_sound(sndSubwayAmbiance, 0, true)
audio_pause_sound(subwayAmbiance)

// Particle systems ----------------------------
walkDustSys = part_system_create()
walkDust = part_type_create()
walkDustSpawnFreq = 2.41	// times per second
part_type_size(walkDust,1,2,0,0)
part_type_life(walkDust,30,60)
part_type_speed(walkDust,.4,.8,-.01,0)
part_type_alpha2(walkDust, .5, 0)
part_type_sprite(walkDust,sDust,false,false,true)

cloneDustSys = part_system_create()
cloneDust = part_type_create()
cloneDustSpawnCooldown = new Cooldown(2)	// in frames
part_type_alpha3(cloneDust, 0, .7, 0)
part_type_size(cloneDust,1,2,0,0)
part_type_life(cloneDust,100,320)
part_type_speed(cloneDust,.1,.8,0,.02)
part_type_orientation(cloneDust, 0, 0, 0, 0, true)
part_type_sprite(cloneDust,sCloneParticle,false,false,true)

destructibleParticlesSys = part_system_create()
destructibleParticles = part_type_create()
destructibleParticlesSpawnCooldown = new Cooldown(2)	// in frames
part_type_size(destructibleParticles, 0.5, 1.5, 0, 0)
part_type_life(destructibleParticles, 30, 120)
part_type_speed(destructibleParticles, .5, 3.8, -.1, 0)
var _dir = 90;
var _spread = 70;
part_type_direction(destructibleParticles, _dir - _spread, _dir + _spread, random_range(-1, 1), 4)
part_type_alpha3(destructibleParticles, 1, 1, 0.5)
//part_type_gravity(destructibleParticles, .1, 270)
part_type_sprite(destructibleParticles, sDestructibleParticle, false, false, true)

explosionDustSys = part_system_create()
explosionDust = part_type_create()
part_type_size(explosionDust,1,3,0,0)
part_type_life(explosionDust,30,110)
part_type_speed(explosionDust,2.,11.,-.3,0)
part_type_alpha2(explosionDust, .7, 0)
part_type_direction(explosionDust, 0, 360, 0, 0)
part_type_sprite(explosionDust,sDust,false,false,true)

bulletImpactSys = part_system_create()
bulletImpact = part_type_create()
part_type_size(bulletImpact,1,2,0,0)
part_type_life(bulletImpact,15,30)
part_type_speed(bulletImpact,1.,2.,-.1,0)
part_type_alpha2(bulletImpact, .7, 0)
part_type_direction(bulletImpact, 0, 360, 0, 0)
part_type_sprite(bulletImpact,sDust,false,false,true)

cloneExplosionSys = part_system_create()
cloneExplosion = part_type_create()
part_type_alpha3(cloneExplosion, 0, 1, 0)
part_type_life(cloneExplosion,30,100)
part_type_direction(cloneExplosion, 0, 360, 0, 0)
part_type_speed(cloneExplosion,.8,5.,-.15,0)
part_type_sprite(cloneExplosion,sCleanerCloneParticle,false,false,false)
part_type_blend(cloneExplosion, true)

// ---------------------------------------------

// Highlight if there is a new interaction
questNPC = CHARACTER_TYPE.student
studentLeft = false

prevRoom = rmLobby

//
instance_create_layer(-50,-50,"Instances", oPlayer)

// Custscenes
introCutscene = true
IntroScene()
