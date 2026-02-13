label = ""

alphaDef = .5
alpha = alphaDef

interactFunc = function(){show_debug_message("Undefined interact function!")}

stepFunc = function(){}

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