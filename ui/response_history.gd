extends ScrollContainer
class_name GameResponseHistoryContainer;

@export var maxHistory: int = 25;

var _gameResponse: PackedScene 	= preload("res://ui/gameplay/game_response.tscn");

@onready var bar: VScrollBar = get_v_scroll_bar();
@onready var _history: VBoxContainer = $"HistoryContainer";

func PushResponseElement(element: ResponseElement) -> void:
	_history.add_child(element);
	if (_history.get_child_count() > maxHistory):
		_history.get_child(0).queue_free();

func PushResponse(gameText: String) -> void:
	var res: ResponseElement = _gameResponse.instantiate();
	res.SetText(gameText);
	PushResponseElement(res);

func Clear() -> void:
	for child in _history.get_children():
		child.queue_free();
	return;

func _ready() -> void:
	bar.changed.connect(ScrollDown);
	
func ScrollDown() -> void:
	#if(scroll_vertical < bar.max_value): # could make it so it only auto scrolls if within 1 page
	scroll_vertical = bar.max_value;
