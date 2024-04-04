extends Node
class_name GameNarrator;

signal change_area(args: PackedStringArray);
signal dialogue_enter(options: Array[CharacterDialogueOption]);
signal dialogue_choice(options: Array[CharacterDialogueOption]);
signal dialogue_exit();

const DIALOGUE_DIR = "res://story/dialogues/{index}.tres";

var _currentOptions: Array[GameRoomOption] = [];

## TODO: Use this as a sort of story controller that handles button input story events

func _LoadDialogue(index: String) -> CharacterDialogue:
	var dia: CharacterDialogue = load(DIALOGUE_DIR.format({"index":index}));
	return dia;

func AddOption(option: GameRoomOption) -> void:
	_currentOptions.push_back(option);
	
func GetOption(index: int) -> GameRoomOption:
	if(index < _currentOptions.size()):
		return _currentOptions[index];
	printerr("Attempting to index invalid option: {index}".format({"index":index}));
	return null;

func GetOptions() -> Array[GameRoomOption]:
	return _currentOptions;	

func ClearOptions() -> void:
	_currentOptions.clear();
	
func Dialogue(args: PackedStringArray) -> void:
	print("Dialogue");
	return;
	
## NOTE: args[0] is area name
## NOTE: args[1] is room name
func ChangeArea(args: PackedStringArray) -> void:
	change_area.emit(args);
