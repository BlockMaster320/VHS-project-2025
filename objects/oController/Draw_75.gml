surface_set_target(guiUpscaledSurf)
//draw_clear_alpha(0, 0)
//draw_surface_ext(guiSurf4x, 0, 0, upscaleMult/6, upscaleMult/6, 0, c_white, 1)
draw_surface_ext(guiSurf, 0, 0, upscaleMult, upscaleMult, 0, c_white, 1)
surface_reset_target()


gpu_set_tex_filter(true)

var scale = window_get_width() / (cameraW * upscaleMult)
draw_surface_ext(guiUpscaledSurf, 0, 0, scale, scale, 0, c_white, 1)

gpu_set_tex_filter(false)
