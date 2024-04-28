extends GameScene

func _init() -> void:
	options = {
		opento 		= GameUIOption.new(OnEnter, "", ""),
		resist 		= GameUIOption.new(Resist1, "Resist", "Fuck this."),
		doresist 	= GameUIOption.new(DoResist1, "...", "..."),
		comply 		= GameUIOption.new(Comply1, "Comply", "Don't make any enemies, yet"),
		docomply 	= GameUIOption.new(DoComply1, "Move", "Do as your'e told"),
		
		exit = GameUIOption.new(Exit, "Move on", "Start your life", Enums.OptionType.action)
	};
	
func OnEnter() -> Array[GameUIOption]:
	MoveToArea("intro_ship","room");
	PushText("Metal creaks and your body feels somewhat compressed. You can tell you're on a ship of some sort, but you can't remember why. You blink, but you can't see.");
	PushText("<guard1>Okay, let's get this one.</guard1>");
	PushText("A swishing sound comes from in front of you and a brush of air hits your face. A hand forcefully grabs your arm and pulls you up.");
	PushText("<guard1>Don't do anything stupid, or we'll beat the shit out of you.</guard1>");
	return [ options.comply, options.resist ];
	
func Resist1() -> Array[GameUIOption]:
	PushText("You resist and are beaten senseless");
	PushText("You vision fades and you lose consciousness");
	return [ options.doresist ];

func DoResist1() -> Array[GameUIOption]:
	push_event.emit(Enums.SceneEvent.uiclear, []);
	MoveToRoom("intero");
	PushText("Your brain feels like it's pressed against your skull.");
	PushText("<guard1>Really? You've been in our custody for like 5 minutes and you already tried to do some shit like that?</guard1>");
	return [ options.exit ];

func Comply1() -> Array[GameUIOption]:
	PushText("You try to get your bearings and slowly move towards the voice.");
	PushText("Being guided by sound and some guidance from the guards, you are snaked through the ships interior until the echo of their voices gets a tad tighter.");
	return [ options.docomply ];

func DoComply1() -> Array[GameUIOption]:
	push_event.emit(Enums.SceneEvent.uiclear, []);
	MoveToRoom("intero");
	PushText("A door closes behind you and a hand lands on your shoulder.");
	PushText("<guard1>Sit.</guard1>");
	PushText("You're unsure of what's below you, but you don't really have a choice. You begin to sit down and right as you're about to fall, a cold metal touches you and you land on a chair.");
	return [ options.exit ];
