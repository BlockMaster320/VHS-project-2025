cam = view_camera[0]

viewW = cameraW
viewH = cameraH

//window_set_size(cameraW*2, cameraH*2)

targetOffsetX = 0
targetOffsetY = 0
offsetX = 0
offsetY = 0

x = oPlayer.x - (viewW / 2)
y = oPlayer.y - (viewH / 2)

lerpSpd = 0.4

mouseViewOffsetMult = 0.07

currentShakeAmount = 0
screenShakeRotAmount = 0
camRot = 0
screenshakeDecay = 0.2