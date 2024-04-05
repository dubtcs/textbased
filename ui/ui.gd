extends Control

const MAX_HISTORY: int = 25;

var _historyNode: PackedScene 	= preload("res://ui/gameplay/moment.tscn");
var _gameResponse: PackedScene 	= preload("res://ui/gameplay/game_response.tscn");
var _playerText: PackedScene 	= preload("res://ui/gameplay/PlayerText.tscn");

@onready var _areaControl: GameAreaController = $"AreaControl";
@onready var _narrator: GameNarrator = $"Narrator";
@onready var _uiRoomName: Label = $"Panel/MarginContainer/HBoxContainer/Left/GameInfo/VBoxContainer/Panel/VBoxContainer/RoomTitle";
@onready var _uiHistoryContainer: VBoxContainer = $"Panel/MarginContainer/HBoxContainer/Middle/History/MarginContainer/ScrollContainer/HistoryContainer";
@onready var _uiOptionContainer: GameOptionGrid = $"Panel/MarginContainer/HBoxContainer/Middle/Panel/GameOptionGrid";
@onready var _moveTimer: Timer = $"MoveTimer";
@onready var _optionHint: CanvasLayer = $"OptionHint";

var _canMove: bool = true;

const MOVE_TIME_SEC: float = 0.15;

func _ready() -> void:
	_optionHint.set_process(false);
	_areaControl.ChangeArea("ship");
	_areaControl.MoveToNamed("main_hallway");
	
	_areaControl.GetCurrentArea().GetCurrentRoom().AddCharacter(Game.Characters.get("meatball"));
	_areaControl.GetCurrentArea().GetRoomNamed("lounge").AddCharacter(Game.Characters.get("shithead"));
	
	RoomEntered();
	PushGameResponse(TextFormat.CharacterMulti("{Shithead} walks around.")) # Shithead walks around
	PushGameResponse(TextFormat.CharacterMulti("{meatball}: {@Shithead} won't like you.")); # He wont like you
	PushGameResponse(TextFormat.CharacterMulti("Something is wrong with {#meatball}.")); # Something is wrong with him
	PushGameResponse(TextFormat.CharacterMulti("{$Shithead} pockets are empty.")) # His pockets are empty
	PushGameResponse(TextFormat.CharacterMulti("{%shithead} not gonna like this.")) # He's not gonna like this
	
func GameTick() -> void:
	#_narrator.TickTime();
	return;
	
func ClearResponseHistory() -> void:
	for child in _uiHistoryContainer.get_children():
		child.queue_free();
	
func PushResponseElement(element: ResponseElement) -> void:
	_uiHistoryContainer.add_child(element);
	if (_uiHistoryContainer.get_child_count() > MAX_HISTORY):
		_uiHistoryContainer.get_child(0).queue_free();
	
## DEPRECATED : Used when this was text based
func PushPlayerInput(playerText: String) -> void:
	var res: ResponseElement = _playerText.instantiate();
	res.SetText(playerText);
	PushResponseElement(res);
	
func PushGameResponse(gameText: String) -> void:
	var res: ResponseElement = _gameResponse.instantiate();
	res.SetText(gameText);
	PushResponseElement(res);
	
func ChangeArea(args: PackedStringArray) -> void:
	var nextName: String = args[0];
	if(_areaControl.ChangeArea(nextName)):
		var roomName: String = args[1];
		_areaControl.MoveToNamed(roomName);
		RoomEntered();
		return;
	return;
	
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
		PushGameResponse(TextFormat.CharacterMulti("{{char}} is passing through".format({"char":char.index})));
		PushOption(char.dialogueOption, index);
		index += 1;
	return;
	
func RoomEntered() -> void:
	_narrator.ClearOptions();
	_uiRoomName.text = _areaControl.GetCurrentArea().GetCurrentRoom().GetName();
	PushGameResponse(_areaControl.GetCurrentArea().GetCurrentRoom().GetDescription());
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
				ClearResponseHistory(); # This might be stupid
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
