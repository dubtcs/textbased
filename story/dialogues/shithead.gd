extends GameCharacterDialogue

func _init() -> void:
	options = {
		"approach" : GameCharacterDialogueOption.new(_Approach, "Approach", "Approach the figure."),
		"greet" : GameCharacterDialogueOption.new(_Greet, "Greet", "Say Hello"),
		
		"punch" : GameCharacterDialogueOption.new(_Punch, "Punch", "Assault {shithead,him/her/them}."),
		"punchStop" : GameCharacterDialogueOption.new(_PunchStop, "Stop", "Do not attack."),
		"punchContinue" : GameCharacterDialogueOption.new(_PunchContinue, "Continue", "Assault {shithead,him/her/them}."),
		
		"intro1_meatball" : GameCharacterDialogueOption.new(_MeatballIntro1, "Meatball", "Inquire about meatball."),
		"intro1_meatball_asked" : GameCharacterDialogueOption.new(_Intro1MeatballAsked, "Meatball", "Mentioned you asked {Meatball}")
	};
	flags = {
		"hasMet" = "bg_shithead_hasmet"
	};
	return;

func Opener(player: GamePlayer) -> PackedStringArray:
	_player = player;
	if(_player.CheckFlag(flags.hasMet)):
		var options: PackedStringArray = ["greet", "punch"];
		PushText("{Shithead} is standing in the corner, screaming, as usual. {Shithead,he sees/she sees/they see} you approaching and waves.");
		if(_player.CheckFlag("bg_intro1_ready")):
			options.push_back("intro1_meatball");
		if(_player.CheckFlag("bg_intro1_meatball")):
			options.push_back("intro1_meatball_asked");
		return options;
	else:
		PushText("There is a {shithead,man/woman/person} standing in the corner of the room screaming. The sound is deafening but you can make out the words \"I LIVE IN BANGLADESH\"");
		return ["approach"];

func _Approach() -> PackedStringArray:
	PushText("You approach the screaming man slowly. Eventually, {shithead,he realizes/she realizes/they realize} you're near {shithead,him/her/them} and turns to face you.");
	PushText("The room is agonizingly quiet now. You begin to speak up, but right as the words are about to come out, the figure speaks.");
	PushText("<shithead>This is my vocal exercise. Keeps my voice strong and my confidence high. My names {Shithead}, by the way.</shithead>");
	_player.SetFlag(flags.hasMet);
	return [];

func _Greet() -> PackedStringArray:
	PushText("<player>hi</player>");
	PushText("<shithead>Hello, you jackass.</shithead>");
	return [];
	
## INTRO QUEST
func _MeatballIntro1() -> PackedStringArray:
	PushText("<player>Have you seen meatball?</player>");
	PushText("<shithead>Yes, I have. Ask that thing what smells like SHIT.</shithead>");
	_player.RemoveFlag("bg_intro1_ready");
	_player.SetFlag("bg_intro1_shithead");
	return [];
	
func _Intro1MeatballAsked() -> PackedStringArray:
	PushText("<player>I talked to {Meatball}</player>");
	PushText("<shithead>And? What'd {meatball,he/she/they} say?</shithead>");
	if(_player.CheckFlag("bg_intro1_meatball_ok")):
		PushText("<player>Unsure of what it is.</player>");
		PushText("<shithead>And there was no sus?</shithead>");
		PushText("<player>Nah</player>");
	else:
		PushText("<player>Says {meatball,he's/she's/they're} not sure what it is, but full of shit.</player>");
		PushText("<shithead>I don't know how the FUCK that thing got on this ship.</shithead>");
		PushText("<shithead>Thing just appears out of nowhere and pretends to not know what smells like SHIT. When {meatball,HE'S/SHE'S/THEY'RE} the reason it does!</shithead>");
	_player.RemoveFlag("bg_intro1_meatball");
	_player.RemoveFlag("bg_intro1_meatball_ok");
	_player.RemoveFlag("bg_intro1_meatball_doubt");
	return [];
	
	
	
	
func _Punch() -> PackedStringArray:
	PushText("You decide you want to use violence. You take a deep breath and cock back your right arm. {Shithead} looks at you in confusion, unsure of what is happening. You scream as you send your fist flying through the air");	
	PushText("<shithead>I will not hesitate to kill you.</shithead>");
	return ["punchContinue", "punchStop"];

func _PunchStop() -> PackedStringArray:
	PushText("You hesitate. {Shithead,his/her/their} voice was sharp and filled with intent. If you continue the attack, you will surely meet God. You decide to stop while you can.");
	PushText("<player>Sorry.</player>");
	PushText("{Shithead} raises an eyebrow and gives you an unamused look.");
	PushText("<shithead>Yeah. Sure.</shithead>");
	return [];
	
func _PunchContinue() -> PackedStringArray:
	PushText("{Shithead,his/her/their} words mean nothing to you. You press on with the attack with all your strength.");
	PushText("{Shithead} sighs before lookng you dead in the eyes, before... [i]Darkness[/i]");
	PushText("<maker>You dumbass. Why would you do that?</maker>");
	
	## Move this into the Game class as a signal
	PushText("[i]Your relationship with {Shithead} has decreased[/i]");
	#Game.AdjustCharacterVal("shithead", "relationship", -1);
	return [];
