extends GameScene

func _init() -> void:
	options = {
		"news" = GameUIOption.new(News, "News", "Watch news"),
		"sport" = GameUIOption.new(Sports, "Sports", "Watch sports"),
		"fruit" = GameUIOption.new(FruitSensory, "Fruit", "Watch fruit sensory"),
		"watch" = GameUIOption.new(Watch, "Watch", "Watch this.")
	};

func Opener() -> Array[GameUIOption]:
	PushText("You take a seat on the bench and gaze towards the TV.");
	return [ options.news, options.sport, options.fruit ];

func Watch() -> Array[GameUIOption]:
	PushText("Time goes by as you watch your content.");
	return [];

func Sports() -> Array[GameUIOption]:
	PushText("You grab the remote and change to the sports station. You're in luck! It's a game of flop between the futuluhtoogan and the jittleyang.");
	return [options.watch];
	
func News() -> Array[GameUIOption]:
	PushText("You switch the station to CNBNWMBC News to check out the headlines.");
	PushText("[i]Senators debate about recent events on gaming forums leaking confidential military documents because of in-game inaccuracies.[/i]");
	return [options.watch];

func FruitSensory() -> Array[GameUIOption]:
	PushText("The fruit sensory channel.");
	PushText("[i]Various 3D caricatures of fruit dance on screen to modern music from hit artist Aries.[/i]");
	return [options.watch];
