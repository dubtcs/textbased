extends Control
class_name GameInputResponse;

@onready var title: Label = $"Label";
@onready var input: LineEdit = $"LineEdit";

func Disable() -> void:
	$"LineEdit".editable = false;

func SetTitle(msg: String) -> void:
	$"Label".text = msg;
	
func GetInput() -> String:
	return $"LineEdit".text;

func GrabFocus() -> void:
	$"LineEdit".grab_focus();
	return;
