extends Resource
class_name CharacterDialogue2;

var _options: Dictionary = {};

func GetOptions() -> void:
	return;
	
func CallOption(index: String) -> PackedStringArray:
	if(_options.has(index)):
		return _options[index].call();
	printerr("{index} not valid option in dialogue.".format({"index":index}));
	return [];
