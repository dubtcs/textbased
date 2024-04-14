extends GameCharacterDialogue

func _init() -> void:
	options = {
		"approach" = GameCharacterDialogueOption.new(_Approach, "Approach", "Investigate this thing."),
		"eat" = GameCharacterDialogueOption.new(_Eat, "Eat", "Food is food"),
		
		"intro1" = GameCharacterDialogueOption.new(_Intro1, "Smell", "Ask about the smell {Shithead} mentioned."),
		"intro1_ok" = GameCharacterDialogueOption.new(_Intro1OK, "Ok", "{meabtall,he seems/she seems/they seem} not to about the smell"),
		"intro1_doubt" = GameCharacterDialogueOption.new(_Intro1Doubt, "Doubt", "BULLSHIT")
	};
	flags = {
		"hasMet" = "bg_meatball_hasmet"
	};
	
func Opener(player: GamePlayer) -> PackedStringArray:
	_player = player;
	if(_player.CheckFlag(flags.hasMet)):
		var options: PackedStringArray = ["eat"];
		PushText("The familiar ball of meat squirms as if to acknowledge your presence.");
		if(player.CheckFlag("bg_intro1_shithead")):
			options.push_back("intro1");
		return options;
	else:
		PushText("You smell an odor of flesh. You look down to see a writhing mass of red near your feet.");
		return ["approach"];

func _Approach() -> PackedStringArray:
	PushText("Your curiosity pushes you forward.")
	_player.SetFlag(flags.hasMet);
	return [];

func _Eat() -> PackedStringArray:
	PushText("You are hungry. [i]Very[/i] hungry. The ball of meat looks too good and you dive forward to consume it.");
	PushText("<player>I am going to eat you.</player>");
	PushText("<meatball>Damn.</meatball>");
	_player.SetFlag("bg_meatball_eat");
	return [];

## INTRO QUEST RELATED
func _Intro1() -> PackedStringArray:
	PushText("<player>Hey, {Shithead} said there's a weird smell. You know anything about it?</player>");
	PushText("{Meatball} ponders for a moment. The mass seemingly writhing in agony because of the effort.");
	PushText("<meatball>No.</meatball>");
	return ["intro1_ok", "intro1_doubt"];

func _Intro1OK() -> PackedStringArray:
	PushText("<player>Ok, well thanks for the help. Sorry to bother you.</player>");
	PushText("{Meatball} stays silent. You take that as an acknowledgement.");
	_player.RemoveFlag("bg_intro1_shithead");
	_player.SetFlag("bg_intro1_meatball");
	_player.SetFlag("bg_intro1_meatball_ok");
	return [];

func _Intro1Doubt() -> PackedStringArray:
	PushText("<player>Bullshit.</player>");
	PushText("{Meatball} makes a groaning noise an shuffles.");
	_player.RemoveFlag("bg_intro1_shithead");
	_player.SetFlag("bg_intro1_meatball");
	_player.SetFlag("bg_intro1_meatball_doubt");
	return [];	
