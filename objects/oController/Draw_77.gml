gpu_set_tex_filter(true)

var scale = window_get_width() / (cameraW * upscaleMult)
if (surfaceDrawPositionX != 0)
	scale = window_get_height() / (cameraH * upscaleMult)

draw_surface_ext(application_surface, surfaceDrawPositionX, surfaceDrawPositionY, scale, scale, 0, c_white, 1)

gpu_set_tex_filter(false)