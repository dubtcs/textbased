extends Control

const MAX_HISTORY: int = 25;

@onready var _areaControl: GameAreaController = $"AreaControl";
@onready var _narrator: GameNarrator = $"Narrator";
@onready var _uiRoomName: Label = $"Panel/MarginContainer/HBoxContainer/Left/GameInfo/MarginContainer/VBoxContainer/RoomTitle";
@onready var _uiHistory: GameResponseHistoryContainer = $"Panel/MarginContainer/HBoxContainer/Middle/Middle/MarginContainer/ResponseHistory";
@onready var _uiOptionContainer: GameOptionGrid = $"Panel/MarginContainer/HBoxContainer/Middle/Panel/GameOptionGrid";
@onready var _moveTimer: Timer = $"MoveTimer";
@onready var _optionHint: GameOptionHint = $"OptionHint";

var _canMove: bool = true;

const MOVE_TIME_SEC: float = 0.15;

func _ready() -> void:
	_optionHint.set_process(false);
	_areaControl.ChangeArea("ship");
	_areaControl.MoveToNamed("main_hallway");
	
	_areaControl.GetCurrentArea().GetCurrentRoom().AddCharacter(Game.Characters.get("meatball"));
	_areaControl.GetCurrentArea().GetRoomNamed("lounge").AddCharacter(Game.Characters.get("shithead"));
	
	RoomEntered();
	
func GameTick() -> void:
	#_narrator.TickTime();
	PushGameResponse(str(_narrator.GetPlayer().Quests().GetStatus("test_quest")));
	return;
	
func PushGameResponse(gameText: String) -> void:
	_uiHistory.PushResponse(gameText);
	
func ChangeArea(args: PackedStringArray) -> void:
	var nextName: String = args[0];
	if(_areaControl.ChangeArea(nextName)):
		var roomName: String = args[1];
		_areaControl.MoveToNamed(roomName);
		RoomEntered();
	return;
	
func OnDialogueChoice(responses: PackedStringArray, options: Array[GameRoomOption]) -> void:
	var index: int = 0;
	_narrator.ClearOptions();
	_uiOptionContainer.ClearButtons();
	for res: String in responses:
		PushGameResponse(GameText.Format(res));
	for opt: GameRoomOption in options:
		PushOption(opt, index);
		index += 1;
	return;
	
func OnDialogueEnter() -> void:
	_canMove = false;
	_uiHistory.Clear();
	return;

func OnDialogueText(text: String) -> void:
	PushGameResponse(GameText.Format(text));

func OnDialogueOptions(options: Array[GameRoomOption]) -> void:
	_narrator.ClearOptions();
	_uiOptionContainer.ClearButtons();
	var index: int = 0;
	for option: GameRoomOption in options:
		PushOption(option, index);
		index += 1;
	return;
	
func OnDialogueExit() -> void:
	RoomEntered();
	_canMove = true;
	
func PushOption(option: GameRoomOption, index: int) -> void:
	_uiOptionContainer.AddButton(option, index);
	_narrator.AddOption(option);

func FillRoomOptions() -> void:
	_uiOptionContainer.ClearButtons();
	_narrator.ClearOptions();
	var room: GameRoom = _areaControl.GetCurrentArea().GetCurrentRoom();
	var index: int = 0;
	for option: GameRoomOption in room.GetOptions():
		PushOption(option, index);
		index += 1;
	for char: GameCharacter in room.GetCharacters().values():
		PushGameResponse(GameText.Format("{{char}} is in the area.".format({"char":char.index})));
		PushOption(char.interactOption, index);
		index += 1;
	return;
	
func RoomEntered() -> void:
	_uiHistory.Clear();
	_narrator.ClearOptions();
	_uiRoomName.text = _areaControl.GetCurrentArea().GetCurrentRoom().GetName();
	PushGameResponse(GameText.Format(_areaControl.GetCurrentArea().GetCurrentRoom().GetDescription()));
	FillRoomOptions();
	
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

func _onGameOptionActivated(index: int) -> void:
	var option: GameRoomOption = _narrator.GetOption(index);
	if(option):
		if(not option.callback.is_empty()):
			_narrator.call(option.callback, option.callbackParams);
	pass;

func _onGameOptionHovered(_button: GameOptionButton) -> void:
	_optionHint.set_process(true);
	_optionHint.visible = true;
	_optionHint.SetOption(_narrator.GetOption(_button.rawOptionIndex));
	
func _onGameOptionExited(_button: GameOptionButton) -> void:
	_optionHint.visible = false;
	_optionHint.set_process(false);
