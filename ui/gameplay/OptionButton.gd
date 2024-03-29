extends Button

@export var _userInputEventName: String = "";

#@onready var _hotkey: Button = $"Hotkey";

# Called when the node enters the scene tree for the first time.
func _ready():
	#if(not _userInputEventName.is_empty()):
		#var ev: InputEventAction = InputEventAction.new();
		#ev.action = _userInputEventName;
		#_hotkey.shortcut.events.push_back(ev);
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
