extends Resource
class_name GameScene;

## TODO: Used for more control over GameDialogue
## Used to lock player controls, move the player, change area, adjust time, etc...

signal push_text(msg: String);
signal push_event(type: Enums.SceneEvent, args: PackedStringArray); # Adding an option, teleporting, locking movement, etc...
signal exit_scene();

var options: Dictionary = {};
var player: GamePlayer = null;

# Abstract
func OnEnter() -> Array[GameUIOption]:
	return [];
func OnExit() -> void:
	return;
	
# msg: Unformatted text
func PushText(msg: String) -> void:
	push_text.emit(msg);
	
func MoveToArea(areaName: String, roomName: String) -> void:
	push_event.emit(Enums.SceneEvent.transport, [areaName,roomName]);
	
func MoveToRoom(roomName: String) -> void:
	push_event.emit(Enums.SceneEvent.movement, [roomName]);

func StartInput(title: String = "INPUT") -> void:
	push_event.emit(Enums.SceneEvent.input, [title]);
	
func FinishInput() -> void:
	push_event.emit(Enums.SceneEvent.inputhandled, []);
	
func GetInput() -> String:
	return Game.UI_INPUT_BUFFER;
	
func ClearHistory() -> void:
	push_event.emit(Enums.SceneEvent.uiclear, []);
	
func Enter(playern: GamePlayer) -> Array[GameUIOption]:
	player = playern;
	return OnEnter();
	
func Exit() -> void:
	OnExit();
	player = null;
	exit_scene.emit();
	return;

## TODO: Need a way to show a game button without it being tied to a character or GameRoomOption
func GetButtonContent() -> PackedStringArray:
	return [];
