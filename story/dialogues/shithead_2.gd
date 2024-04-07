extends GameCharacterDialogue

func _init() -> void:
	options = {
		"opener" : _Opener
	};
	flags = {
		"hasMet" = "hasmet_shithead"
	};
	return;

func _Opener() -> void:
	if(Game.CheckFlag(flags.hasMet)):
		PushText("{Shithead} is standing in the corner, screaming, as usual.");
	else:
		PushText("There is a {shithead,man/woman/person} standing in the corner of the room screaming. The sound is deafening but you can make out the words \"I LIVE IN BANGLADESH\"");
		Game.SetFlag(flags.hasMet);
	return;
