extends Node

var _flags: Dictionary = {};

func GetFlag(flagName: String) -> bool:
	return _flags.has(flagName);

func SetFlag(flagName: String) -> void:
	_flags[flagName] = true;
	
func RemoveFlag(flagName: String) -> void:
	if(_flags.has(flagName)):
		_flags.erase(flagName);
