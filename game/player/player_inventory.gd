extends Node
class_name PlayerInventory;

var _items: Dictionary = {};

func HasItem(index: String) -> bool:
	return _items.has(index);
	
func GetItem(index: String) -> int:
	if(HasItem(index)):
		return _items.get(index);
	return 0;
	
func AddItem(index: String) -> void:
	_items[index] += 1;
