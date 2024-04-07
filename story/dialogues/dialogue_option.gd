extends Resource
class_name GameCharacterDialogueOption;

var text: String = "";
var hint: String = "";
var fn: Callable = Callable();

func _init(callback: Callable, text_: String = "", hint_: String = "") -> void:
	text = text_;
	hint = hint_;
	fn = callback;
