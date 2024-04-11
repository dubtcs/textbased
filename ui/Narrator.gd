extends Node
class_name GameNarrator;

signal change_area(args: PackedStringArray);
signal dialogue_text(text: String);
signal dialogue_options(options: Array[GameRoomOption]);
signal dialogue_enter();
signal dialogue_exit();

const DIALOGUE_DIR = "res://story/dialogues/{index}.gd";

var player: GamePlayer = GamePlayer.new();

var _currentOptions: Array[GameRoomOption] = [];
var currentDialogue: GameCharacterDialogue = null;

func GetPlayer() -> GamePlayer:
	return player;

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
	if(currentDialogue):
		currentDialogue.Exit();
	return;

func Dialogue(args: PackedStringArray) -> void:
	if(currentDialogue):
		if(currentDialogue.is_connected("dialogue_text", EmitDialogueText)):
			currentDialogue.disconnect("dialogue_text", EmitDialogueText);
	var character: GameCharacter = Game.Characters.get(args[0]);
	if(character):
		dialogue_enter.emit();		
		currentDialogue = character.dialogue;
		var retOptions: Array[GameRoomOption] = [];
		if(currentDialogue):
			currentDialogue.connect("dialogue_text", EmitDialogueText);
			var options: PackedStringArray = currentDialogue.Opener(player);
			
			for optionIndex: String in options:
				var option: GameCharacterDialogueOption = currentDialogue.options.get(optionIndex);
				if(option):
					var button: GameRoomOption = GameRoomOption.new();
					button.name = option.text;
					button.description = option.hint;
					button.callback = "DialogueChoice";
					button.callbackParams = [args[0], optionIndex];
					retOptions.push_back(button); # why tf did I call this button?
					
		var gb: GameRoomOption = GameRoomOption.new();
		gb.callback = "DialogueExit";
		gb.name = "Leave";
		gb.description = "Exit this interaction";
		gb.callback = "DialogueExit";
		retOptions.push_back(gb);
		
		dialogue_options.emit(retOptions);
	return;
	
func DialogueChoice(args: PackedStringArray) -> void:
	if(args.size() < 2):
		printerr("Dialogue button supplied with insufficient args.");
		return;
	var charIndex: String = args[0];
	if(Game.Characters.has(charIndex)):
		var character: GameCharacter = Game.Characters.get(charIndex);
		var retOptions: Array[GameRoomOption] = [];
		if(currentDialogue):
			var curIndex: String = args[1];
			var options: PackedStringArray = currentDialogue.CallOption(curIndex);
			if(options):
				for optionIndex: String in options:
					var option: GameCharacterDialogueOption = currentDialogue.options.get(optionIndex);
					if(option):
						var button: GameRoomOption = GameRoomOption.new();
						button.name = option.text;
						button.description = option.hint;
						button.callback = "DialogueChoice";
						button.callbackParams = [args[0], optionIndex];
						retOptions.push_back(button); # why tf did I call this button?
				dialogue_options.emit(retOptions);
				return;
		
		# Either there was no option, or the option had no responses, so we're going back to the hub
		var gb: GameRoomOption = GameRoomOption.new();
		gb.callback = "Dialogue";
		gb.name = "Back";
		gb.description = "Talk about something else";
		gb.callbackParams = args;
		retOptions.push_back(gb);
		dialogue_options.emit(retOptions);
		
	return;
	
## NOTE: args[0] is area name
## NOTE: args[1] is room name
func ChangeArea(args: PackedStringArray) -> void:
	change_area.emit(args);

func EmitDialogueText(text: String) -> void:
	dialogue_text.emit(text);

func _ready() -> void:
	player.Quests().Start("test_quest");
