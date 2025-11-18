subImage = clamp(subImage + (isOpen * 2 - 1) * 0.3, 0, 8);
draw_sprite(sprite_index, floor(subImage), x, y);

//sprite_set_bbox_mode(sprite_index, bboxmode_fullimage);