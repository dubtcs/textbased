extends CharacterDialogue2

# This form of dialogue structure can allow for conditional quest progress or some shit

func _init() -> void:
	_options = {
		"opener" : func() -> PackedStringArray:
			var responses: PackedStringArray = [];
			return [];,
		"greet" : func() -> PackedStringArray:
			return [];,
	}
