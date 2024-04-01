extends Node
class_name GameNarrator;

signal change_area(args: PackedStringArray);
signal enter_dialogue(options: PackedStringArray);

var _currentOptions: Array[GameRoomOption] = [];

## TODO: Use this as a sort of story controller that handles button input story events

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

## NOTE: args[0] is character id
## NOTE: args[1] is current dialogue index
func Dialogue(args: PackedStringArray) -> void:
	if(args.size() >= 1):
		var options: Array[CharacterDialogueOption] = [];
		## TODO: Fetch dialogue resrouces, fill with options of current index
		enter_dialogue.emit(args);
	return;
	
## NOTE: args[0] is area name
## NOTE: args[1] is room name
func ChangeArea(args: PackedStringArray) -> void:
	change_area.emit(args);
