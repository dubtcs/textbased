extends Node

const MAX_SPLITS: int = 1;

func ProcessInput(cmd: String) -> String:
	var rv: String = "";
	var commands: PackedStringArray = cmd.split(" ", false, MAX_SPLITS);
	match(commands[0].to_lower()):
		"use":
			rv = "Used!";
		"enter":
			rv = "Entering <area>";
		_:
			rv = "You can't do that in this context.";
	return rv;
