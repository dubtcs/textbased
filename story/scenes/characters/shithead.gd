extends GameScene

func _init() -> void:
	options = {
		approach = GameUIOption.new(Approach, "Approach", "Approach the figure."),
		attack = GameUIOption.new(Attack, "Attack", "Attack this person."),
		talk = GameUIOption.new(Talk, "Talk", "Chat about anything"),
		howgo = GameUIOption.new(HowGoes, "Ship", "Ask about what there is to do."),
		whoyou = GameUIOption.new(WhoAreYou, "Employment", "Ask why this was their career."),
		
		exit = GameUIOption.new(Exit, "Goodbye", "Say goodbye", Enums.OptionType.action)
	};
	return;

func OnEnter() -> Array[GameUIOption]:
	if(player.CheckFlag("bg_shithead_hasmet")):
		PushText("{Shithead} gives you a familiar smile.");
		return [ options.talk, options.attack, options.exit ];
	else:
		PushText("A figure sits in the corner screaming. Genuinely tweaking.");
		return [ options.approach, options.exit ];

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

func Talk() -> Array[GameUIOption]:
	PushText("You shift your weight and decide to take a seat next to {shithead}. You both wait a moment before you speak up.");
	PushText("<shithead>What's up?</shithead>");
	return [ options.howgo, options.whoyou ];

func HowGoes() -> Array[GameUIOption]:
	PushText("<player>About this ship. Is there anything on here at all interesting? I've only been here for a few minutes and I can already feel the boredom coming on.</player>");
	PushText("{Shithead} chuckles before taking a breath.");
	PushText("<shithead>No, but we might get something soon. A new... [i]thing[/i] arrived just before you did. Got no idea what it is. It's like this giant ball of meat. Like a literal meatball.</shithead>");
	return [];

func WhoAreYou() -> Array[GameUIOption]:
	PushText("<player>Who are you? Like, what made you decide to do this?</player>");
	PushText("<shithead>idk I'm just a temp character while tools are workflow are made.</shithead>");
	return [];
