extends CanvasLayer
class_name GameOptionHint;

@onready var _title: Label = $"PanelContainer/MarginContainer/VBoxContainer/Title";
@onready var _desc: Label = $"PanelContainer/MarginContainer/VBoxContainer/Desc";

func SetOption(option: GameUIOption) -> void:
	_title.text = option.title;
	_desc.text = GameText.Format(option.description);

func _process(_dt: float) -> void:
	offset = get_viewport().get_mouse_position();
