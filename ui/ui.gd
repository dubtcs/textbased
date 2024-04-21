extends Control

const MAX_HISTORY: int = 25;

@onready var _areaControl: GameAreaController = $"AreaControl";
@onready var _narrator: GameNarrator = $"Narrator";
@onready var _uiRoomName: Label = $"Panel/MarginContainer/HBoxContainer/Left/GameInfo/MarginContainer/VBoxContainer/RoomTitle";
@onready var _uiOptionContainer: GameOptionGrid = $"Panel/MarginContainer/HBoxContainer/Middle/Panel/GameOptionGrid";
@onready var _uiContent: GameContentContainer = $"Panel/MarginContainer/HBoxContainer/Middle/GameContent";
@onready var _moveTimer: Timer = $"MoveTimer";
@onready var _optionHint: GameOptionHint = $"OptionHint";

var _canMove: bool = true;

const MOVE_TIME_SEC: float = 0.15;

func _ready() -> void:
	_optionHint.set_process(false);
	_areaControl.ChangeArea("ship");
	_areaControl.MoveToNamed("main_hallway");
	
	_narrator.quest_progress.connect(_uiContent.UpdateQuests);
	
	_areaControl.GetCurrentArea().GetCurrentRoom().AddCharacter(Game.Characters.get("meatball"));
	_areaControl.GetCurrentArea().GetRoomNamed("lounge").AddCharacter(Game.Characters.get("shithead"));
	
	_uiContent.FillQuests(_narrator.GetPlayer().Quests());
	RoomEntered();
	
func GameTick() -> void:
	PushGameResponse(str(_narrator.GetPlayer().Quests().GetStatus("test_quest")));
	return;
	
func PushGameResponse(gameText: String) -> void:
	_uiContent.PushResponse(gameText);
	
func PushOption(option: GameUIOption, index: int) -> void:
	_narrator.AddOption(option);
	_uiOptionContainer.AddUIButton(option, index);
	return;
	
func ChangeArea(args: PackedStringArray) -> void:
	var nextName: String = args[0];
	if(_areaControl.ChangeArea(nextName)):
		var roomName: String = args[1];
		_areaControl.MoveToNamed(roomName);
		RoomEntered();
	return;

func OnSceneText(text: String) -> void:
	PushGameResponse(GameText.Format(text));

func OnSceneOptions(options: Array[GameUIOption]) -> void:
	_narrator.ClearOptions();
	_uiOptionContainer.ClearButtons();
	var index: int = 0;
	for option: GameUIOption in options:
		PushOption(option, index);
		index += 1;
	return;

func OnSceneEnter() -> void:
	_canMove = false;
	_uiContent.ClearHistory();

func OnSceneExit() -> void:
	RoomEntered();
	_canMove = true;
	
func ConstructCharacterOption(character: GameCharacter) -> GameUIOption:
	return GameUIOption.new(_narrator.EnterScene.bind(character.dialogue), character.name, "Approach " + character.name);
	
func ConstructStaticOption(container: GameRoomSceneContainer) -> GameUIOption:
	return GameUIOption.new(_narrator.EnterScene.bind(container.scene), container.name, container.description);

func FillRoomOptions() -> void:
	_uiOptionContainer.ClearButtons();
	_narrator.ClearOptions();
	var room: GameRoom = _areaControl.GetCurrentArea().GetCurrentRoom();
	var index: int = 0;
	for scene: GameRoomSceneContainer in room.GetScenes().values():
		PushOption(ConstructStaticOption(scene), index);
		index += 1;
	for char: GameCharacter in room.GetCharacters().values():
		PushGameResponse(GameText.Format("{{char}} is in the area.".format({"char":char.index})));
		PushOption(ConstructCharacterOption(char), index);
		index += 1;
	return;
	
func RoomEntered() -> void:
	_uiContent.ClearHistory();
	_narrator.ClearOptions();
	_uiRoomName.text = _areaControl.GetCurrentArea().GetCurrentRoom().GetName();
	PushGameResponse(GameText.Format(_areaControl.GetCurrentArea().GetCurrentRoom().GetDescription()));
	FillRoomOptions();
	
## TODO: This ignores narrator!!!
func _input(event: InputEvent) -> void:
	var didMove: bool = false;
	if(_canMove):
		if(not _moveTimer.time_left):
			if(event.is_action_pressed("moveNorth")):
				didMove = _areaControl.AttemptMove(Enums.MoveDirection.north);
			elif(event.is_action_pressed("moveEast")):
				didMove = _areaControl.AttemptMove(Enums.MoveDirection.east);
			elif(event.is_action_pressed("moveSouth")):
				didMove = _areaControl.AttemptMove(Enums.MoveDirection.south);
			elif(event.is_action_pressed("moveWest")):
				didMove = _areaControl.AttemptMove(Enums.MoveDirection.west);
			if(didMove):
				_moveTimer.start(MOVE_TIME_SEC);
				_onGameOptionExited(null); # what the fuck
				RoomEntered();
				GameTick();
	return;

func _onUIOptionActivated(index: int) -> void:
	_narrator.CallOption(index);
		
func _onGameOptionHovered(_button: GameOptionButton) -> void:
	_optionHint.set_process(true);
	_optionHint.visible = true;
	_optionHint.SetOption(_narrator.GetOption(_button.rawOptionIndex));
	
func _onGameOptionExited(_button: GameOptionButton) -> void:
	_optionHint.visible = false;
	_optionHint.set_process(false);

func _onPageChanged(controls: bool) -> void:
	_canMove = controls;
	$"Panel/MarginContainer/HBoxContainer/Middle/Panel/GameOptionGrid".visible = controls;
	return;
