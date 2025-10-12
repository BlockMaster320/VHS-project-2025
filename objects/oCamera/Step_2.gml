// Center around player (fixed position)

var centeredX = oPlayer.x - (viewW / 2)
var centeredY = oPlayer.y - (viewH / 2)

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
camera_set_view_pos(cam, x, y)
camera_set_view_angle(cam, camRot)