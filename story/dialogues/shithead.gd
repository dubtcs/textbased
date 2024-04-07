extends GameCharacterDialogue

func _init() -> void:
	options = {
		"greet" : GameCharacterDialogueOption.new(_Greet, "Greet", "Say Hello"),
		"punch" : GameCharacterDialogueOption.new(_Punch, "Punch", "Assault {shithead,him/her/them}.")
	};
	flags = {
		"hasMet" = "hasmet_shithead"
	};
	return;

func Opener() -> PackedStringArray:
	if(Game.CheckFlag(flags.hasMet)):
		PushText("{Shithead} is standing in the corner, screaming, as usual. {Shithead,he sees/she sees/they see} you approaching and waves.");
	else:
		PushText("There is a {shithead,man/woman/person} standing in the corner of the room screaming. The sound is deafening but you can make out the words \"I LIVE IN BANGLADESH\"");
		Game.SetFlag(flags.hasMet);
	return ["greet", "punch"];

func _Greet() -> PackedStringArray:
	PushText("[player]hi[/player]");
	PushText("[shithead]Hello, you jackass.[/shithead]");
	return [];
	
func _Punch() -> PackedStringArray:
	PushText("You decide you want to use violence. You take a deep breath and cock back your right arm. {Shithead} looks at you in confusion, unsure of what is happening. You scream as you send your fist flying through the air");	
	PushText("[shithead]I will not hesitate to kill you.[/shithead]");
	return [];
