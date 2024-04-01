extends Node
class_name GameNarrator;

signal change_area(args: PackedStringArray);
signal enter_dialogue();

## TODO: Use this as a sort of story controller that handles button input story events

func Dialogue(args: PackedStringArray) -> void:
	enter_dialogue.emit();
	print("We be speaking");
	
func ChangeArea(args: PackedStringArray) -> void:
	change_area.emit(args);
