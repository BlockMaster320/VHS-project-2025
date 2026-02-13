// Center around player (fixed position)

var centeredX = roundPixelPos(oPlayer.x) - (viewW / 2)
var centeredY = roundPixelPos(oPlayer.y) - (viewH / 2)

// Follow mouse cursor (target position)

var xMouseOff = (device_mouse_x_to_gui(0) - display_get_gui_width()/2) * mouseViewOffsetMult
var yMouseOff = (device_mouse_y_to_gui(0) - display_get_gui_height()/2) * mouseViewOffsetMult

// Screenshake (target position)
var screenshakeOffX = random_range(-currentShakeAmount, currentShakeAmount)
var screenshakeOffY = random_range(-currentShakeAmount, currentShakeAmount)

screenShakeRotAmount = currentShakeAmount * 0.15
camRot = random_range(-screenShakeRotAmount, screenShakeRotAmount)

currentShakeAmount = lerp(currentShakeAmount, 0, screenshakeDecay)

// Evaluate position

targetOffsetX = xMouseOff + screenshakeOffX
targetOffsetY = yMouseOff + screenshakeOffY

offsetX = lerp(offsetX, targetOffsetX, lerpSpd)
offsetY = lerp(offsetY, targetOffsetY, lerpSpd)

x = centeredX + offsetX
y = centeredY + offsetY

x = clamp(x, 0, room_width - viewW)
y = clamp(y, 0, room_height - viewH)

// Update camera

camera_set_view_size(cam, viewW, viewH)
camera_set_view_pos(cam, roundPixelPos(x), roundPixelPos(y))
camera_set_view_angle(cam, camRot)


// Instance deactivation -----------------------------------------

var viewCenterX = x + cameraW/2
var viewCenterY = y + cameraH/2

if (!point_in_rectangle(viewCenterX, viewCenterY, regionLeft, regionTop, regionRight, regionBottom))
{
	var time = get_timer()
	
	instance_deactivate_object(oCollider)
	instance_deactivate_object(oDestructible)
	instance_deactivate_object(oWeaponPickup)
	instance_deactivate_object(oBuffPickup)
	
	instance_activate_object(oPower)
	instance_activate_object(oDoorEscalator)
	instance_activate_object(oEscalatorDialogue)
	instance_activate_object(oEscalatorBarrier)
	
	var activateLeft = viewCenterX - cameraW
	var activateTop = viewCenterY - cameraH
	var activateWidth = cameraW*2
	var activateHeigth = cameraH*2	
	instance_activate_region(activateLeft, activateTop, activateWidth, activateHeigth, true)
	
	regionLeft = activateLeft + cameraW*.7
	regionTop = activateTop + cameraH*.7
	regionRight = activateLeft + activateWidth - cameraW*.7
	regionBottom = activateTop + activateHeigth - cameraH*.7
	
	show_debug_message($"Recalculating active objects (finished in {(get_timer() - time) / 1000} ms)")
}
















