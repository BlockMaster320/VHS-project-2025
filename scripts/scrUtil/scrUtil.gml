function roundPixelPos(pos)
{
	// Align to grid for nice pixel art upscaling
	return round(pos * oController.upscaleMult) / oController.upscaleMult
}

function updateUpscaleFactor()
{
	// Get nearest integer multiple of camera width
	var smallestError = infinity
	var targetW = window_get_width()

	for (var mult = 1; mult < 10; mult++) // Set a limit, just to be safe
	{
		/*var currentMult = cameraW * mult
		var error = abs(currentMult - targetW)
	
		if (error < smallestError) smallestError = error*/
		
		if (targetW < cameraW * mult)
		{
			oController.upscaleMult = mult
			surface_resize(application_surface, cameraW * oController.upscaleMult, cameraH * oController.upscaleMult)
			break
		}
	}
}