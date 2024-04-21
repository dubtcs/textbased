extends Resource
class_name GameScene;

## TODO: Used for more control over GameDialogue
## Used to lock player controls, move the player, change area, adjust time, etc...

signal push_text(msg: String);
signal push_event(); # Adding an option, teleporting, locking movement, etc...

var options: Dictionary = {};
var player: GamePlayer = null;

## MUST IMPLEMENT THIS IN EVERY SCENE
func Opener() -> Array[GameUIOption]:
	return [];
# GameDialogue previously passed string arrays, but objects are passed by reference, so this is better



# @msg: Unformatted text
func PushText(msg: String) -> void:
	push_text.emit(msg);

func Enter(playern: GamePlayer) -> Array[GameUIOption]:
	player = playern;
	return Opener();
	
func Exit() -> void:
	player = null;

## TODO: Need a way to show a game button without it being tied to a character or GameRoomOption
func GetButtonContent() -> PackedStringArray:
	return [];
