extends LineEdit

func _ready() -> void:
	grab_focus();

func ClearInput(_garbage: String) -> void:
	clear();
