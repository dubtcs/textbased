extends VBoxContainer

#@onready var bar: VScrollBar = get_v_scroll_bar();

#func _ready() -> void:
	#bar.changed.connect(CorrectScrollMax);
#
#func CorrectScrollMax() -> void:
	#bar.scroll_vertical = bar.max_value;
