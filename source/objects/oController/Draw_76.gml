//surface_resize(application_surface, cameraW, cameraH)

if (windowWidthPrev != window_get_width() or windowHeightPrev != window_get_width() or appWindowXprev != window_get_x() or appWindowYprev != window_get_y())
{
	//display_set_gui_size(window_get_width(), window_get_height())
	updateUpscaleFactor()
}

windowWidthPrev = window_get_width()
windowHeightPrev = window_get_width()