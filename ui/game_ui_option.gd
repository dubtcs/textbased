extends Resource
class_name GameUIOption;

var title: String = "";
var description: String = "";
var callback: Callable = Callable();

func _init(_callback: Callable, _title: String = "", _description: String = "") -> void:
	title = _title;
	description = _description;
	callback = _callback;
	return;
