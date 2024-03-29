extends Control

const MAX_HISTORY: int = 25;

var _historyNode: PackedScene 	= preload("res://ui/gameplay/moment.tscn");
var _gameResponse: PackedScene 	= preload("res://ui/gameplay/GameResponse.tscn");
var _playerText: PackedScene 	= preload("res://ui/gameplay/PlayerText.tscn");

@onready var _areaControl: GameAreaController = $"AreaControl";
@onready var _gameLogic: GameLogicController = $"GameControl";
@onready var _uiRoomName: Label = $"Panel/MarginContainer/HBoxContainer/Left/GameInfo/VBoxContainer/Panel/VBoxContainer/RoomTitle";
@onready var _uiHistoryContainer: VBoxContainer = $"Panel/MarginContainer/HBoxContainer/Middle/History/MarginContainer/ScrollContainer/HistoryContainer";
@onready var _moveTimer: Timer = $"MoveTimer";
@onready var _optionHint: CanvasLayer = $"OptionHint";

const MOVE_TIME_SEC: float = 0.15;

func _ready() -> void:
	_optionHint.set_process(false); # hide this sh
	_areaControl.ChangeArea("test_room");
	_areaControl.GetCurrentArea().MoveTo(0,0);
	PushGameResponse("Hello asshole c:");
	PushPlayerInput("Damn, okay");
	
func ClearResponseHistory() -> void:
	for child in _uiHistoryContainer.get_children():
		child.queue_free();
	
func PushResponseElement(element: ResponseElement) -> void:
	_uiHistoryContainer.add_child(element);
	if (_uiHistoryContainer.get_child_count() > MAX_HISTORY):
		_uiHistoryContainer.get_child(0).queue_free();
	
func PushPlayerInput(playerText: String) -> void:
	var res: ResponseElement = _playerText.instantiate();
	res.SetText(playerText);
	PushResponseElement(res);
	
func PushGameResponse(gameText: String) -> void:
	var res: ResponseElement = _gameResponse.instantiate();
	res.SetText(gameText);
	PushResponseElement(res);
	
func OnMoveToScenePress(but: Button) -> void:
	_areaControl.ChangeArea(but.text);
	_areaControl.GetCurrentArea().MoveTo(0,0);
	return;
	
func _input(event: InputEvent) -> void:
	var didMove: bool = false;
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
			ClearResponseHistory(); # This might be stupid
			_uiRoomName.text = _areaControl.GetCurrentArea().GetCurrentRoom().GetName();
			PushGameResponse("You enter: " + _areaControl.GetCurrentArea().GetCurrentRoom().GetName());
			PushGameResponse(_areaControl.GetCurrentArea().GetCurrentRoom().GetDescription());
	return;


func _onGameOptionHovered(_button: Button) -> void:
	_optionHint.set_process(true);
	_optionHint.visible = true;
	
func _onGameOptionExited(_button: Button) -> void:
	_optionHint.visible = false;
	_optionHint.set_process(false);
