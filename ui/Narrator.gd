extends Node
class_name GameNarrator;

signal change_area(args: PackedStringArray);
signal enter_dialogue(options: Array[CharacterDialogueOption]);

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

## NOTE: args[0] is character id
## NOTE: args[1] is current dialogue index
func Dialogue(args: PackedStringArray) -> void:
	print(args);
	if(args.size() >= 2):
		var index: int = int(args[1]);
		var options: Array[GameRoomOption] = [];
		var responses: PackedStringArray = [];
		## TODO: Fetch dialogue resrouces, fill with options of current index
		var dia: CharacterDialogue = _LoadDialogue(args[0]);
		if(dia):
			var curdia: CharacterDialogueOption = dia.dialogues[index];
			## TODO: Move this to game controller. This shouldn't be done here
			responses.push_back(TextFormat.CharacterSpeech(Game.Characters.player, curdia.playerText));
			responses.push_back(TextFormat.CharacterSpeech(Game.Characters.get(args[0]), curdia.characterResponse));
			
			if(curdia.responseOptions.size() > 0):
				for optionIndex: int in dia.dialogues[index].responseOptions:
					var opt: CharacterDialogueOption = dia.dialogues[optionIndex];
					var rm: GameRoomOption = GameRoomOption.new();
					#rm.buttonIndex = i;
					rm.callback = "Dialogue";
					rm.callbackParams = [args[0], optionIndex];
					rm.name = opt.buttonText;
					rm.description = opt.buttonHint;
					options.push_back(rm);
			else:
				# send the player back to the "hub" dialogue option
				var rm: GameRoomOption = GameRoomOption.new();
				rm.callback = "Dialogue";
				rm.callbackParams = [args[0], 0];
				rm.name = dia.dialogues[0].buttonText;
				rm.description = dia.dialogues[0].buttonHint;
				options = [rm];
				
		enter_dialogue.emit(responses, options);
	return;
	
## NOTE: args[0] is area name
## NOTE: args[1] is room name
func ChangeArea(args: PackedStringArray) -> void:
	change_area.emit(args);
