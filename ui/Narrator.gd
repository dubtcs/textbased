extends Node
class_name GameNarrator;

signal change_area(args: PackedStringArray);
signal emit_text(text: String);
signal emit_options(options: Array[GameUIOption]);
signal emit_event(type: Enums.SceneEvent, args: PackedStringArray);
signal scene_exit();
signal scene_enter();

signal quest_progress(quests: Array[GamePlayerQuest]);

const DIALOGUE_DIR = "res://story/dialogues/{index}.gd";

var player: GamePlayer = GamePlayer.new();

var currentScene: GameScene = null;
var currentSceneOptions: Array[GameUIOption] = [];
var exitOption: GameUIOption = GameUIOption.new(ExitScene, "Exit", "Exit this interaction");
#var spoofOption: GameUIOption = GameUIOption.new(GetPlayer, "__SPOOF");

var INTRO_SCENE: GameScene = preload("res://story/scenes/intro_scene.gd").new();

func GetPlayer() -> GamePlayer:
	return player;
	
func AddOption(option: GameUIOption) -> void:
	currentSceneOptions.push_back(option);
	return;
	
func GetOption(index: int) -> GameUIOption:
	if(index < currentSceneOptions.size()):
		return currentSceneOptions[index];
	return null;
	
func GetOptions() -> Array[GameUIOption]:
	return currentSceneOptions;

func ClearOptions() -> void:
	currentSceneOptions.clear();
	
func ConstructBackOption(scene: GameScene) -> GameUIOption:
	return GameUIOption.new(EnterScene.bind(scene), "Back", "Go back");
	
func EnterScene(scene: GameScene) -> Array[GameUIOption]:
	scene_enter.emit();
	if(currentScene):
		if(currentScene.is_connected("push_text", EmitText)):
			currentScene.disconnect("push_text", EmitText);
		if(currentScene.is_connected("push_event", EmitSceneEvent)):
			currentScene.disconnect("push_event", EmitSceneEvent);
		if(currentScene.is_connected("exit_scene", EmitSceneEvent)):
			currentScene.disconnect("exit_scene", ExitScene);
	if(scene):
		currentScene = scene;
		currentScene.push_text.connect(EmitText);
		currentScene.push_event.connect(EmitSceneEvent);
		currentScene.exit_scene.connect(ExitScene);
		var options: Array[GameUIOption] = currentScene.Enter(player);
		return options;
	else:
		currentScene = null;
		return [exitOption];
	
func ExitScene() -> void:
	scene_exit.emit();

func CallScene(option: GameUIOption) -> void:
	var options: Array[GameUIOption] = option.callback.call();
	if(options.is_empty()):
		options.push_back(ConstructBackOption(currentScene));
	if(options[0] != exitOption): ## REALLY fucking stupid way to get around this
		EmitOptions(options);
	return;
	
func CallAction(option: GameUIOption) -> void:
	option.callback.call();
	return;
	
func CallOption(index: int) -> void:
	if(index < currentSceneOptions.size()):
		var option: GameUIOption = currentSceneOptions[index];
		match(option.type):
			Enums.OptionType.scene:
				CallScene(option);
			Enums.OptionType.action:
				CallAction(option);
	else:
		printerr("No option of index: " + str(index));
	return;
	
# Manually begin a scene
func StartScene(scene: GameScene) -> void:
	var options: Array[GameUIOption] = EnterScene(scene);
	if(options.is_empty()):
		options.push_back(ConstructBackOption(currentScene));
	if(options[0] != exitOption): ## REALLY fucking stupid way to get around this
		EmitOptions(options);
	return;

func EmitText(text: String) -> void:
	emit_text.emit(text);
	
func EmitSceneEvent(type: Enums.SceneEvent, args: PackedStringArray) -> void:
	emit_event.emit(type, args);

func EmitOptions(options: Array[GameUIOption]) -> void:
	emit_options.emit(options);

func _OnPlayerQuestProgress(q: Array[GamePlayerQuest]) -> void:
	quest_progress.emit(q);

func _ready() -> void:
	print_debug("Adding test quests");
	player.quest_progress.connect(_OnPlayerQuestProgress);
	player.Quests().Start("intro");
	player.Quests().Start("another");
	player.SetFlag("bg_intro1_ready");
