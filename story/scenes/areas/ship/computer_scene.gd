extends GameScene

func _init() -> void:
	options = {
		"up" = GameUIOption.new(_Up, "Up", "Go up")
	};

func Opener() -> Array[GameUIOption]:
	print("opening");
	PushText("You go to the staircase. Up or down?");
	if(player.CheckFlag("bg_shithead_hasmet")):
		PushText("Shithead has been here.");
	return [ options.up ];

func _Up() -> Array[GameUIOption]:
	print("going up");
	PushText("GO UP!");
	return [];
