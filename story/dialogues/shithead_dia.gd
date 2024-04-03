extends CharacterDialogue2

func _init() -> void:
	_options = {
		"opener" : func() -> void:
			print(1);
	}
