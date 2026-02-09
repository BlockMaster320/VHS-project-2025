for (var i = 0; i < array_length(connectedInstances); i++)
{
	if (instance_exists(connectedInstances[i]))
		instance_destroy(connectedInstances[i])
}
