//draw_sprite_ext(sCursor, 0, device_mouse_x(0), device_mouse_y(0), 1, 1, 0, c_white, 1)

if (instance_exists(oCamera))
{
	gpu_set_blendmode_ext(bm_dest_color, bm_zero)
	draw_set_alpha(1)
		
	//shader_set(shShadowFilter)
	//	shader_set_uniform_f(timeLocShadow, current_time)
	//	draw_surface(lightSurface, surfaceDrawPositionX, surfaceDrawPositionY)
	//shader_reset()
	
	//draw_set_alpha(1)
	
	shader_set(shLightFilter)
		shader_set_uniform_f(timeLocLight, (current_time)%9999)
		
		gpu_set_blendmode_ext(bm_dest_color, bm_zero)
		draw_surface_ext(lightSurface, oCamera.x - safetyMargin, oCamera.y - safetyMargin, 1, 1, 0, c_white, 1)
		
		gpu_set_blendmode_ext(bm_one, bm_one)
		draw_surface_ext(lightSurface, oCamera.x - safetyMargin, oCamera.y - safetyMargin, 1, 1, 0, c_white, .05)
		
	shader_reset()
	gpu_set_blendmode(bm_normal)
	draw_set_alpha(1)
	
	//draw_surface(lightSurface, surfaceDrawPositionX, surfaceDrawPositionY)
}


if (room == rmMenu && introCutscene)
{
	draw_sprite_ext(sFullscreenButton, 0, 1321, 117, 3.44, 3.44, 0, c_white, 1)
	introTextAlpha = lerp(introTextAlpha, .6, .001)
	draw_set_alpha(introTextAlpha)
	var scale = 2
	draw_text_transformed(60, 60, "Press Backspace to skip cutscene", scale, scale, 0)
	draw_set_alpha(1)
}
else if (room == rmMenu)
{
	var centerX = room_width/2
	var centerY = room_height/2
	
	var lerpFac = .005
	
	if (menuShowCredits1)
	{
		menuShowCredits1Alpha = lerp(menuShowCredits1Alpha, 1, lerpFac)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		
		draw_set_alpha(menuShowCredits1Alpha)
		var scale = 15
		draw_text_transformed(centerX, centerY-80, "Wandless", scale, scale, 0)
		
	}
	if (menuShowCredits2)
	{
		menuShowCredits2Alpha = lerp(menuShowCredits2Alpha, 1, lerpFac)
		draw_set_alpha(menuShowCredits2Alpha)
		var scale = 2
		draw_text_transformed(	centerX, centerY+60,
								"Ondřej Václavík, Jakub Rybář, Viet Hoa Nguyenová, Tomáš Němeček",
								scale, scale, 0)
	}
	if (menuShowCredits3)
	{
		menuShowCredits3Alpha = lerp(menuShowCredits3Alpha, 1, lerpFac)
		draw_set_alpha(menuShowCredits3Alpha)
		var scale = 2
		draw_text_transformed(	centerX, centerY+130,
								"Press backspace for a new run.\n(Try holding Ctrl+Shift+T to discover a secret.)",
								scale, scale, 0)
			
		if (keyboard_check(vk_shift) and keyboard_check(vk_control) and keyboard_check(ord("T")))
		{
			if (debugRoomHoldCd.value <= 0)
			{
				debugRoomHoldCd.reset()
				gameReset(rmDebug)
			}
			else debugRoomHoldCd.value--
		} else debugRoomHoldCd.reset()
								
		if (keyboard_check_pressed(vk_backspace))
		{
			menuShowCredits1 = false
			menuShowCredits2 = false
			menuShowCredits3 = false
			menuShowCredits1Alpha = 0
			menuShowCredits2Alpha = 0
			menuShowCredits3Alpha = 0
			
			gameReset()
		}
	}
	
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	
	draw_set_alpha(1)
}


















