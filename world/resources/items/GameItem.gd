extends Resource
class_name GameItem;

@export var _itemName: String = "ITEM";

func GetName() -> String:
	return _itemName;
