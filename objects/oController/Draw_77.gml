gpu_set_tex_filter(true)

var scale = window_get_width() / (cameraW * upscaleMult)
if (surfaceDrawPositionX != 0)
	scale = window_get_height() / (cameraH * upscaleMult)

if (instance_exists(oCamera))
{
	shader_set(shExposure)
	
	var tex = surface_get_texture(lightSurface)
	var texLoc = shader_get_sampler_index(shExposure, "lightmap");
	texture_set_stage(texLoc, tex)
	
	shader_set_uniform_f_array(texelSizeLoc, [lightTexW, lightTexH])
	
	draw_surface_ext(application_surface, surfaceDrawPositionX, surfaceDrawPositionY, scale, scale, 0, c_white, 1)
	
	shader_reset()
}
else draw_surface_ext(application_surface, surfaceDrawPositionX, surfaceDrawPositionY, scale, scale, 0, c_white, 1)

gpu_set_tex_filter(false)