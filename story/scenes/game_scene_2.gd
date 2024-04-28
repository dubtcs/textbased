extends Node
class_name GameScene2;

signal push_text(msg: String);
signal push_event(type: Enums.SceneEvent, args: PackedStringArray);
signal push_options(options: Array[GameUIOption]);
signal exit_scene();
signal enter_scene();

var options: Dictionary = {};
var player: GamePlayer = null;

# Abstract
func OnAction(args: PackedStringArray) -> void:
	printerr("No OnAction() definition found for scene.");
	return;
# Abstract
func OnScene(args: PackedStringArray) -> void:
	printerr("No OnScene() definition found for scene.");
	return;
# Abstract
func OnUpdate() -> void:
	return;
# Abstract
func OnStart() -> void:
	printerr("No OnStart() definition found for scene.")
	return;
# Abstract
func OnExit() -> void:
	printerr("No OnExit() definition found for scene.")
	return;


## BUILT IN PROVIDED

func PushText(msg: String) -> void:
	push_text.emit(msg);

func MoveToArea(area: String, room: String) -> void:
	push_event.emit(Enums.SceneEvent.transport, [area,room]);
func MoveToRoom(room: String) -> void:
	push_event.emit(Enums.SceneEvent.movement, [room]);

func Start(plr: GamePlayer) -> void:
	player = plr;
	OnStart();
	return;

func Option(option: GameOptionButton) -> void:
	match(option):
		Enums.OptionType.action:
			OnAction(option.args);
		Enums.OptionType.scene:
			OnScene(option.args);
		_:
			printerr("Invalid OptionType enum");
	return;
	
func Exit() -> void:
	OnExit();
	player = null;
	return;
