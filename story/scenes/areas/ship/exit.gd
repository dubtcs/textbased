extends GameScene;

func _init() -> void:
	options = {
		"hatch" : GameUIOption.new(UseHatch, "Hatch", "Exit the ship")
	};
	return;

func Opener() -> Array[GameUIOption]:
	PushText("The hatch sits in front of you, ready to open.");
	return [options.hatch];

func UseHatch() -> Array[GameUIOption]:
	PushText("")
	return [];
