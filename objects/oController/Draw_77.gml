var scale = window_get_width() / (cameraW * upscaleMult)

gpu_set_tex_filter(true)
draw_surface_ext(application_surface, 0, 0, scale, scale, 0, c_white, 1)
gpu_set_tex_filter(false)