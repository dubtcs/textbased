extends Node
class_name GameNarrator;

signal change_area(args: PackedStringArray);
signal emit_text(text: String);
signal emit_options(options: Array[GameUIOption]);
signal scene_exit();
signal scene_enter();

signal quest_progress(quests: Array[GamePlayerQuest]);

const DIALOGUE_DIR = "res://story/dialogues/{index}.gd";

var player: GamePlayer = GamePlayer.new();

var currentScene: GameScene = null;
var currentSceneOptions: Array[GameUIOption] = [];
var exitOption: GameUIOption = GameUIOption.new(ExitScene, "Exit", "Exit this interaction");

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
	currentScene = scene;
	currentScene.push_text.connect(EmitText);
	var options: Array[GameUIOption] = currentScene.Enter(player);
	options.push_back(exitOption);
	return options;
	
func ExitScene() -> Array[GameUIOption]:
	scene_exit.emit();
	return [];
	
func CallOption(index: int) -> void:
	if(index < currentSceneOptions.size()):
		var option: GameUIOption = currentSceneOptions[index];
		var options: Array[GameUIOption] = option.callback.call();
		if(options.is_empty()):
			options.push_back(ConstructBackOption(currentScene));
		EmitOptions(options);
	return;

func EmitText(text: String) -> void:
	emit_text.emit(text);

func EmitOptions(options: Array[GameUIOption]) -> void:
	emit_options.emit(options);
