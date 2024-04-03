extends Node
class_name GameNarrator;

signal change_area(args: PackedStringArray);
signal enter_dialogue(entryText: String, options: Array[CharacterDialogueOption]);
signal exit_dialogue();
signal dialogue_step(responses: PackedStringArray, options: Array[GameRoomOption]);

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

## NOTE: This is used for the entrance to dialogue, not per step
## NOTE: args[0] is character id
## NOTE: args[1] is current dialogue index
func Dialogue(args: PackedStringArray) -> void:
	if(args.size() < 2):
		return;
	var charId: String = args[0];
	var options: Array[GameRoomOption] = [];
	var responses: PackedStringArray = [];
	var dia: CharacterDialogue = _LoadDialogue(charId);
	if(dia):
		for i: int in dia.startingOptions:
			var opt: CharacterDialogueOption = dia.dialogues[i];
			var rm: GameRoomOption = GameRoomOption.new();
			rm.callback = "DialogueStep";
			rm.callbackParams = [charId, i];
			rm.name = opt.buttonText;
			rm.description = opt.buttonHint;
			options.push_back(rm);
		# Add the goodbye button to the hub
		var rm: GameRoomOption = GameRoomOption.new();
		rm.callback = "DialogueEnd";
		rm.callbackParams = [args[0], 0];
		rm.name = "Goodbye";
		rm.description = "Exit from conversation.";
		options.push_back(rm);
		enter_dialogue.emit(Game.Characters.get(charId).description, options);
		
func DialogueStep(args: PackedStringArray) -> void:
	if(args.size() < 2):
		return;
	var charId: String = args[0];
	var choiceIndex: int = int(args[1]);
	var options: Array[GameRoomOption] = [];
	var responses: PackedStringArray = [];
	var dia: CharacterDialogue = _LoadDialogue(charId);
	if(dia):
		var curChoice: CharacterDialogueOption = dia.dialogues[choiceIndex];
		
		responses.push_back(TextFormat.CharacterSpeech(Game.Characters.player, curChoice.playerText));
		responses.push_back(TextFormat.CharacterSpeech(Game.Characters.get(charId), curChoice.characterResponse));
		
		if(curChoice.responseOptions.is_empty()):
			Dialogue(args); # Back to hub options
		else:
			for i: int in curChoice.responseOptions:
				var option: CharacterDialogueOption = dia.dialogues[i];
				var rm: GameRoomOption = GameRoomOption.new();
				rm.callback = "DialogueStep";
				rm.callbackParams = [charId, i];
				rm.name = option.buttonText;
				rm.description = option.buttonHint;
				options.push_back(rm);
			dialogue_step.emit(responses, options);
	return;
	
func DialogueEnd(_args: PackedStringArray) -> void:
	exit_dialogue.emit();
	
## NOTE: args[0] is area name
## NOTE: args[1] is room name
func ChangeArea(args: PackedStringArray) -> void:
	change_area.emit(args);
