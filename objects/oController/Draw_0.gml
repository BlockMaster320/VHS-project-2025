// Lighting --------------------------

if (!instance_exists(oCamera)) return;

var camOffX = oCamera.x
var camOffY = oCamera.y

var shadowLightAlpha = .8	// These shouldn't add up over one - that would cause clipping
var overlayLightAlpha = .1
var vignetteAlpha = .1
var shadowCol = make_color_hsv(0,0,150)
var shadowLightSize = 150 * cameraToGui
var overlayLightSize = 150 * cameraToGui

surface_set_target(lightSurface)

	draw_clear_alpha(shadowCol, 1)
	
	var plX = (oPlayer.x-camOffX)*cameraToGui
	var plY = (oPlayer.y-camOffY)*cameraToGui
	
	//draw_circle_color(0,0,100,c_white,c_white,0)
	//gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, )
	draw_circle_color(plX,plY,shadowLightSize,make_color_hsv(0,0,shadowLightAlpha*255),shadowCol,0)
	//draw_sprite(sLight,0,x-surfOffX,y-surfOffY)
		
	draw_set_color(shadowCol)
	//gpu_set_blendmode(bm_subtract)
	for (var i = -9; i < 9; i++)
	{
		for (var j = -7; j < 7; j++)
		{
			var xx = oPlayer.x + (i * TILE_SIZE)
			var yy = oPlayer.y + (j * TILE_SIZE)
			xx -= (xx % TILE_SIZE) //- (TL_SIZE / 2)	//Odsazené = vlevo nahoře tilu
			yy -= (yy % TILE_SIZE) //- (TL_SIZE / 2)	//Neodsazené = center
			if (tilemap_get_at_pixel(global.tilemapCollision, xx, yy))
			{
				// Convert camera space to gui space
				xx = (xx-camOffX) * cameraToGui
				yy = (yy-camOffY) * cameraToGui
				//draw_circle(xx,yy,5,0)
				
				// Draw shadows
				var bbLeft = xx
				var bbRight = xx + TILE_SIZE*cameraToGui
				var bbTop = yy
				var bbBott = yy + TILE_SIZE*cameraToGui
				var shadowLength = (guiW - point_distance(xx,yy,bbLeft+8,bbRight+8)) * .7
				var x2 = bbLeft +	lengthdir_x(shadowLength,point_direction(plX,plY,bbLeft,bbTop))
				var y2 = bbTop +	lengthdir_y(shadowLength,point_direction(plX,plY,bbLeft,bbTop))
				var x3 = bbRight +	lengthdir_x(shadowLength,point_direction(plX,plY,bbRight,bbBott))
				var y3 = bbBott +	lengthdir_y(shadowLength,point_direction(plX,plY,bbRight,bbBott))
													
				var x4 = bbRight +	lengthdir_x(shadowLength,point_direction(plX,plY,bbRight,bbTop))
				var y4 = bbTop +	lengthdir_y(shadowLength,point_direction(plX,plY,bbRight,bbTop))
				var x5 = bbLeft +	lengthdir_x(shadowLength,point_direction(plX,plY,bbLeft,bbBott))
				var y5 = bbBott +	lengthdir_y(shadowLength,point_direction(plX,plY,bbLeft,bbBott))
					
				draw_primitive_begin(pr_trianglefan)
				draw_vertex(bbLeft,bbTop)
				draw_vertex(x2,y2)
				draw_vertex(x3,y3)
				draw_vertex(bbRight,bbBott)
					
				draw_vertex(bbRight,bbTop)
				draw_vertex(x4,y4)
				draw_vertex(x5,y5)
				
				draw_vertex(bbLeft,bbBott)
				draw_primitive_end()
					
				draw_rectangle(bbLeft,bbTop,bbRight-1,bbBott-1,false)
			}
		}
	}
	
	draw_set_alpha(overlayLightAlpha)
	gpu_set_blendmode(bm_add)
	draw_circle_color(plX,plY,overlayLightSize,c_white,c_black,0)
	draw_set_alpha(1)
	
	// Simple vignette
	var centerX = window_get_width()/2
	var centerY = window_get_height()/2
	//draw_circle_color(centerX,centerY ,window_get_width()*.7,make_color_hsv(0,0,vignetteAlpha*255),c_black,0)
	gpu_set_blendmode_ext(bm_dest_color, bm_zero)
	draw_circle_color(centerX,centerY,window_get_width()*.7,c_white,c_black,0)
	
	gpu_set_blendmode(bm_normal)
	draw_set_color(c_white)
	
	//draw_set_alpha(.2)
	//draw_clear(c_black)
	//draw_set_alpha(1)
	
surface_reset_target()