extends Node
class_name PlayerFlagManager;

var _flags: Dictionary = {};

func Check(index: String) -> bool:
	return _flags.has(index);

func Set(index: String) -> void:
	_flags[index] = true;

func Remove(index: String) -> void:
	if(_flags.has(index)):
		_flags.erase(index);
	return;
