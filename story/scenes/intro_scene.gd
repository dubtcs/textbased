extends GameScene

func _init() -> void:
	_options = {
		"hub" = GameSceneOption.new(_Hub)
	};
	
func _Hub() -> void:
	return;
