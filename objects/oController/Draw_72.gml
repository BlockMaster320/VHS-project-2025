if (!surface_exists(guiSurf))
	guiSurf = surface_create(cameraW, cameraH)
	
if (!surface_exists(guiSurf4x))
	guiSurf4x = surface_create(cameraW*4, cameraH*4)
	
if (!surface_exists(guiUpscaledSurf))
	guiUpscaledSurf = surface_create(cameraW * upscaleMult, cameraH * upscaleMult)
	

surface_set_target(guiSurf)
draw_clear_alpha(0, 0)
surface_reset_target()

surface_set_target(guiSurf4x)
draw_clear_alpha(0, 0)
surface_reset_target()