extends Node
class_name GameNarrator;

## TODO: Use this as a sort of story controller that handles button input story events

var _queue: Array[int] = [];

func AddStory(v: int) -> void:
	_queue.push_back(v);
	return;
	
func RemoveStory() -> void:
	_queue.pop_back();
	return;
