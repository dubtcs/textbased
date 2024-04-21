extends GameScene

func _init() -> void:
	options = {
		"approach" = GameUIOption.new(Approach, "Approach", "Approach the figure."),
		"attack" = GameUIOption.new(Attack, "Attack", "Attack this mf.")
	};
	return;

func Opener() -> Array[GameUIOption]:
	if(player.CheckFlag("bg_shithead_hasmet")):
		PushText("{Shithead} gives you a familiar smile.");
		return [options.attack];
	else:
		PushText("A figure sits in the corner screaming.");
		return [options.approach];

func Approach() -> Array[GameUIOption]:
	PushText("You approach the screaming man slowly. Eventually, {shithead,he realizes/she realizes/they realize} you're near {shithead,him/her/them} and turns to face you.");
	PushText("The room is agonizingly quiet now. You begin to speak up, but right as the words are about to come out, the figure speaks.");
	PushText("<shithead>This is my vocal exercise. Keeps my voice strong and my confidence high. My names {Shithead}, by the way.</shithead>");
	player.SetFlag("bg_shithead_hasmet");
	return [];

func Attack() -> Array[GameUIOption]:
	PushText("You decide you want to use violence. You take a deep breath and cock back your right arm. {Shithead} looks at you in confusion, unsure of what is happening. You scream as you send your fist flying through the air");	
	PushText("<shithead>I will not hesitate to kill you.</shithead>");
	return [];
