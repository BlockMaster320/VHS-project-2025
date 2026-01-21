if (oController.introCutscene) instance_destroy()

if (!instance_exists(oPlayer))
	instance_create_layer(x, y, "Instances", oPlayer)
else
{
	oPlayer.x = x
	oPlayer.y = y
}

instance_destroy()