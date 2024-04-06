extends Node
class_name GameNarrator;

signal change_area(args: PackedStringArray);
signal dialogue_enter(responses: PackedStringArray, options: Array[CharacterDialogueOption]);
signal dialogue_choice(responses: PackedStringArray, options: Array[CharacterDialogueOption]);
signal dialogue_exit();

const DIALOGUE_DIR = "res://story/dialogues/{index}.tres";

var _currentOptions: Array[GameRoomOption] = [];
var currentDialogue: CharacterDialogue = null;

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
	
func CreateGoodbyeOption() -> GameRoomOption:
	var opt: GameRoomOption = GameRoomOption.new();
	opt.callback = "DialogueExit";
	opt.description = "Exit conversation";
	opt.name = "Leave";
	return opt;
	
func DialogueExit(args: PackedStringArray) -> void:
	dialogue_exit.emit();

func Dialogue(args: PackedStringArray) -> void:
	if(args.size() < 2):
		printerr("Dialogue button supplied with insufficient args.");
		return;
	var charIndex: String = args[0];
	if(Game.Characters.has(charIndex)):
		var character: GameCharacter = Game.Characters.get(charIndex);
		currentDialogue = _LoadDialogue(charIndex);
		if(currentDialogue):
			var rOptions: Array[GameRoomOption] = [];
			for optionIndex: int in currentDialogue.startingOptions:
				var cur: CharacterDialogueOption = currentDialogue.dialogues[optionIndex];
				var opt: GameRoomOption = GameRoomOption.new();
				opt.name = cur.buttonText;
				opt.description = cur.buttonHint;
				opt.callback = "DialogueChoice";
				opt.callbackParams = [charIndex, optionIndex];
				rOptions.push_back(opt);
			rOptions.push_back(CreateGoodbyeOption());
			dialogue_enter.emit([character.description], rOptions);
	return;
	
func DialogueChoice(args: PackedStringArray) -> void:
	if(args.size() < 2):
		printerr("Dialogue button supplied with insufficient args.");
		return;
	var charIndex: String = args[0];
	if(Game.Characters.has(charIndex)):
		var character: GameCharacter = Game.Characters.get(charIndex);
		if(currentDialogue):
			var curIndex: int = int(args[1]);
			var rOptions: Array[GameRoomOption] = [];
			if(currentDialogue.dialogues[curIndex].responseOptions.size()):
				for optionIndex: int in currentDialogue.dialogues[curIndex].responseOptions:
					var cur: CharacterDialogueOption = currentDialogue.dialogues[optionIndex];
					var opt: GameRoomOption = GameRoomOption.new();
					opt.name = cur.buttonText;
					opt.description = cur.buttonHint;
					opt.callback = "DialogueChoice";
					opt.callbackParams = [charIndex, optionIndex];
					rOptions.push_back(opt);
			else:
				for optionIndex: int in currentDialogue.startingOptions:
					var cur: CharacterDialogueOption = currentDialogue.dialogues[optionIndex];
					var opt: GameRoomOption = GameRoomOption.new();
					opt.name = cur.buttonText;
					opt.description = cur.buttonHint;
					opt.callback = "DialogueChoice";
					opt.callbackParams = [charIndex, optionIndex];
					rOptions.push_back(opt);
				rOptions.push_back(CreateGoodbyeOption());
			dialogue_choice.emit(currentDialogue.dialogues[curIndex].responses, rOptions);			
	return;
	
## NOTE: args[0] is area name
## NOTE: args[1] is room name
func ChangeArea(args: PackedStringArray) -> void:
	change_area.emit(args);
