extends GameCharacterDialogue

func _init() -> void:
	options = {
		"approach" = GameCharacterDialogueOption.new(_Approach, "Approach", "Investigate this thing."),
		"eat" = GameCharacterDialogueOption.new(_Eat, "Eat", "Food is food")
	};
	flags = {
		"hasMet" = "bg_meatball_hasmet"
	};
	
func Opener(player: GamePlayer) -> PackedStringArray:
	_player = player;
	if(_player.CheckFlag(flags.hasMet)):
		PushText("The familiar ball of meat squirms as if to acknowledge your presence.");
		return ["eat"];
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
