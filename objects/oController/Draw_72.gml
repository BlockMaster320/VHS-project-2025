if (!surface_exists(guiSurf))
	guiSurf = surface_create(cameraW, cameraH)
	
//if (!surface_exists(guiSurf4x))
//	guiSurf4x = surface_create(cameraW*4, cameraH*4)
	
if (!surface_exists(guiUpscaledSurf))
	guiUpscaledSurf = surface_create(cameraW * upscaleMult, cameraH * upscaleMult)
	
if (!surface_exists(lightSurface))
{
	lightSurface = surface_create(cameraW+safetyMargin*2, cameraH+safetyMargin*2)
	var tex = surface_get_texture(lightSurface)
	lightTexW = texture_get_texel_width(tex)
	lightTexH = texture_get_texel_height(tex)
}
	

surface_set_target(guiSurf)
draw_clear_alpha(0, 0)
surface_reset_target()

//surface_set_target(guiSurf4x)
//draw_clear_alpha(0, 0)
//surface_reset_target()

surface_set_target(guiUpscaledSurf)
draw_clear_alpha(0, 0)
surface_reset_target()