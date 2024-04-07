extends Resource
class_name GameCharacterDialogue;

signal dialogue_text(text: String);

var options: Dictionary = {};
var flags: Dictionary = {};

func PushText(text: String) -> void:
	dialogue_text.emit(text);

## NOTE: You MUST implement this for each character dialogue
## This is called to initalize dialogue options
func Opener() -> PackedStringArray:
	return [];

func CallOption(option: String) -> PackedStringArray:
	if(options.has(option)):
		return options.get(option).fn.call();
	return [];
