extends GameScene

func _init() -> void:
	options = {
		opento 		= GameUIOption.new(OnEnter, "", ""),
		resist 		= GameUIOption.new(Resist1, "Resist", "Fuck this."),
		doresist 	= GameUIOption.new(DoResist1, "...", "..."),
		comply 		= GameUIOption.new(Comply1, "Comply", "Don't make any enemies, yet"),
		docomply 	= GameUIOption.new(DoComply1, "Move", "Do as your'e told"),
		doname 		= GameUIOption.new(DoName, "Write", "Write your name."),
		
		exit 		= GameUIOption.new(Exit, "Move on", "Start your life", Enums.OptionType.action)
	};
	
func OnExit() -> void:
	MoveToArea("ship","main_hallway");
	return;
	
func OnEnter() -> Array[GameUIOption]:
	MoveToArea("intro_ship","room");
	PushText("Metal creaks and your body feels somewhat compressed. You can tell you're on a ship of some sort, but you can't remember why. You blink, but you can't see and your face feels completely covered.");
	PushText("<guard1>Okay, let's get this one.</guard1>");
	PushText("A swishing sound comes from in front of you and a hand forcefully grabs your arm, pulling you up.");
	PushText("<guard1>Don't do anything stupid, or we'll beat the shit out of you.</guard1>");
	return [ options.comply, options.resist ];
	
func Resist1() -> Array[GameUIOption]:
	player.SetFlag("quest_intro_doresist");
	PushText("You resist and are beaten senseless");
	PushText("You vision fades and you lose consciousness");
	return [ options.doresist ];

func DoResist1() -> Array[GameUIOption]:
	ClearHistory();
	MoveToRoom("heal");
	PushText("Your brain feels like it's pressed against your skull.");
	PushText("<guard1>Really? You've been in our custody for like 5 minutes and you already tried to do some shit like that?</guard1>");
	PushText("As your vision recovers and your headache subsides, you can see the {Guard} messing with a tablet.");
	PushText("<guard1>Here.</guard1>");	
	PushText("{Guard1,He throws/She throws/They throw} the tablet in your direction.");
	PushText("<guard1>Tyope your fucking name and don't do anything stupid.</guard1>");
	player.SetFlag("quest_intro_doresist");
	StartInput("NAME");
	return [ options.doname ];

func Comply1() -> Array[GameUIOption]:
	PushText("You try to get your bearings and slowly move towards the voice.");
	PushText("Being guided by sound and some guidance from the guards, you are snaked through the ships interior until the echo of their voices gets a tad tighter.");
	return [ options.docomply ];

func DoComply1() -> Array[GameUIOption]:
	ClearHistory();
	MoveToRoom("heal");
	PushText("A door closes behind you and a hand lands on your shoulder.");
	PushText("<guard1>Sit.</guard1>");
	PushText("You're unsure of what's below you, but you don't really have a choice. You begin to sit down and right as you're about to fall, a cold metal touches you and you land on a chair.");
	PushText("<guard1>We just need your name for our records. Type it here.</guard1>");
	PushText("{guard1,He hands/She hands/They hand} you a bulky tablet and points to the screen. There is a single window simply titled [i]NAME[/i]");
	StartInput("NAME");
	return [ options.doname ];

func DoName() -> Array[GameUIOption]:
	if(player.CheckFlag(Game.UI_INPUT_FLAG)):
		player.RemoveFlag(Game.UI_INPUT_FLAG);
		FinishInput();
		Game.Characters.get("player").name = GetInput();
		if(player.CheckFlag("quest_intro_doresist")):
			if(player.CheckFlag("quest_intro1_emptysubmit")):
				PushText("{Guard1,He gives/She gives/They give} you a look of disgust as {guard1,he tries/she tries/they try} try to comprehend your struggle of such a simple task.");
			PushText("<guard1>See... {Player}? It's not hard.</guard1>");
			PushText("{Guard1,he takes/she takes/they take} the tablet from you and begin cycling through menus.");
		else:
			if(player.CheckFlag("quest_intro1_emptysubmit")):
				PushText("{Guard1,He rolls his/She rolls her/They roll their} eyes when you finally make up your mind.");
			PushText("Once you've completed the form, {guard1,he grabs/she grabs/they grab} the tablet from you and begin cycling through menus.");
		PushText("<guard1>So, {Player}, now we just need some general info about yourself. Should be self explanatory.</guard1>");
		PushText("{guard1,He returns/She returns/They return} the tablet to you, this time containing multiple field and forms.");
		player.RemoveFlag("quest_intro1_emptysubmit");
		return [ options.exit ];
		
	elif(not player.CheckFlag("quest_intro1_emptysubmit")):
		player.SetFlag("quest_intro1_emptysubmit")
		PushText("<guard1>Really? Just... type your name.</guard1>");
	return [ options.doname ];
