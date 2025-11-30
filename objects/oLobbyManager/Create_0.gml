wallGrid = getWallGrid(["TilesWall"]);
pfGrid = getPathfindingGrid(wallGrid)

graph = new StateGraph(
	0,
	[
		new State(0),
		new State(1),
		new State(2)
	],
	[
		new Transition(
			0, 
			LAMBDA { return 1 }
		),
		new Transition(
			1,
			LAMBDA { return 2 }
		),
		new Transition(
			2, 
			LAMBDA { if (random(2)>=1) return 0 else return 1 }
		)
	]
)
 
debug(graph.get())
debug(graph.next())
debug(graph.next())
debug(graph.next())
debug(graph.next())
debug(graph.next())
debug(graph.next())