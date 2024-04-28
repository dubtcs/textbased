extends Resource
class_name GameUIOption;

var title: String = "";
var description: String = "";
var callback: Callable = Callable();
var type: Enums.OptionType = Enums.OptionType.scene;

func _init(_callback: Callable, _title: String = "", _description: String = "", optionType: Enums.OptionType = Enums.OptionType.scene) -> void:
	title = _title;
	description = _description;
	callback = _callback;
	type = optionType;
	return;
