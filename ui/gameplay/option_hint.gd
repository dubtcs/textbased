extends CanvasLayer
class_name GameOptionHint;

@onready var _title: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/Title";
@onready var _desc: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/Desc";

func SetOption(option: GameRoomOption) -> void:
	_title.text = option.name;
	_desc.text = option.description;

func _process(_dt: float) -> void:
	offset = get_viewport().get_mouse_position();
