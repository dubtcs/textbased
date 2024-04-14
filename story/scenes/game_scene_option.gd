extends Resource
class_name GameSceneOption;

var title: String = "";
var description: String = "";
var fn: Callable;

func _init(callback: Callable, titlen: String = "", desciptionn: String = "") -> void:
	fn = callback;
	title = titlen;
	description = desciptionn;
	return;
