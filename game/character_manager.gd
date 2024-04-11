extends Resource
class_name GameCharacterManager;

var _characters: Dictionary = {};

func Has(index: String) -> bool:
	return _characters.has(index);

func Get(index: String) -> GameCharacter:
	if(Has(index)):
		return _characters.get(index);
	return;

func _init() -> void:
	return;
