extends GameCharacterDialogue

func _init() -> void:
	options = {
		"approach" : GameCharacterDialogueOption.new(_Approach, "Approach", "Approach the figure."),
		"greet" : GameCharacterDialogueOption.new(_Greet, "Greet", "Say Hello"),
		"punch" : GameCharacterDialogueOption.new(_Punch, "Punch", "Assault {shithead,him/her/them}."),
		"punchStop" : GameCharacterDialogueOption.new(_PunchStop, "Stop", "Do not attack."),
		"punchContinue" : GameCharacterDialogueOption.new(_PunchContinue, "Continue", "Assault {shithead,him/her/them}.")
	};
	flags = {
		"hasMet" = "bg_hasmet_shithead"
	};
	return;

func Opener() -> PackedStringArray:
	if(Game.CheckFlag(flags.hasMet)):
		PushText("{Shithead} is standing in the corner, screaming, as usual. {Shithead,he sees/she sees/they see} you approaching and waves.");
		return ["greet", "punch"];
	else:
		PushText("There is a {shithead,man/woman/person} standing in the corner of the room screaming. The sound is deafening but you can make out the words \"I LIVE IN BANGLADESH\"");
		return ["approach"];

func _Approach() -> PackedStringArray:
	PushText("You approach the screaming man slowly. Eventually, {shithead,he realizes/she realizes/they realize} you're near {shithead,him/her/them} and turns to face you.");
	PushText("The room is agonizingly quiet now. You begin to speak up, but right as the words are about to come out, the figure speaks.");
	PushText("<shithead>This is my vocal exercise. Keeps my voice strong and my confidence high. My names {Shithead}, by the way.</shithead>");
	Game.SetFlag(flags.hasMet);
	return [];

func _Greet() -> PackedStringArray:
	PushText("<player>hi</player>");
	PushText("<shithead>Hello, you jackass.</shithead>");
	return [];
	
func _Punch() -> PackedStringArray:
	PushText("You decide you want to use violence. You take a deep breath and cock back your right arm. {Shithead} looks at you in confusion, unsure of what is happening. You scream as you send your fist flying through the air");	
	PushText("<shithead>I will not hesitate to kill you.</shithead>");
	return ["punchContinue", "punchStop"];

func _PunchStop() -> PackedStringArray:
	PushText("You hesitate. {Shithead,his/her/their} voice was sharp and filled with intent. If you continue the attack, you will surely meet God. You decide to stop while you can.");
	PushText("<player>Sorry.</player>");
	PushText("{Shithead} raises an eyebrow and gives you an unamused look.");
	PushText("<shithead>Yeah. Sure.</shitead>");
	return [];
	
func _PunchContinue() -> PackedStringArray:
	PushText("{Shithead,his/her/their} words mean nothing to you. You press on with the attack with all your strength.");
	PushText("{Shithead} sighs before lookng you dead in the eyes, before... [i]Darkness[/i]");
	PushText("<maker>You dumbass. Why would you do that?</maker>");
	Game.AdjustCharacterVal("shithead", "relationship", -1);
	return [];
