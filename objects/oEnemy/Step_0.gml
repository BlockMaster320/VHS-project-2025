controller.step()


if (controller.characterState != CharacterState.Dead) {
	if (random(1) < 0.05) {  // 5% chance each step to pick a new target
	    targetX = startX + random_range(-2, 2);
	    targetY = startY + random_range(-2, 2);
	}

	// Smoothly move toward target
	x = lerp(x, targetX, 0.1);
	y = lerp(y, targetY, 0.1);
}