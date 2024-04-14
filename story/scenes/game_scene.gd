extends Node
class_name GameScene;

## TODO: Used for more control over GameDialogue
## Used to lock player controls, move the player, change area, adjust time, etc...

signal push_text(msg: String);

var _options: Dictionary = {};
var _player: GamePlayer = null;

func Pushtext(msg: String) -> void:
	push_text.emit(msg);

func Enter(player: GamePlayer) -> void:
	_player = player;
	
func Exit() -> void:
	_player = null;

func CallOption(index: String) -> PackedStringArray:
	if(_options.has(index)):
		return _options.get(index).fn.call();
	return [];
