extends Resource
class_name GameCharacterDialogue;

signal dialogue_push(text: String);

var options: Dictionary = {};
var flags: Dictionary = {};

func PushText(text: String) -> void:
	dialogue_push.emit(text);
