extends Node
class_name GameLogicController;

const MAX_SPLITS: int = 1;

const _commandKeywords: Dictionary = {
	"enter" : Enums.ActionType.movement,
	"go" 	: Enums.ActionType.movement,
	"use"	: Enums.ActionType.interaction,
	"@"		: Enums.ActionType.meta
};

func DeconstructCommand(cmd: String) -> PackedStringArray:
	return cmd.split(" ", false, MAX_SPLITS);

func ProcessInputType(cmd: String) -> Enums.ActionType:
	if(_commandKeywords.has(cmd)):
		return _commandKeywords[cmd];
	return Enums.ActionType.invalid;

func ProcessInput(cmd: String) -> String:
	var rv: String = "";
	var cmds: PackedStringArray = DeconstructCommand(cmd);
	match(cmds[0]):
		"enter":
			return "You enter";
		"use":
			return "You use";
		_:
			return "You stupid.";
