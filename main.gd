extends Control

var HistoryNode: PackedScene 	= preload("res://ui/gameplay/moment.tscn");
var _gameResponse: PackedScene 	= preload("res://ui/gameplay/GameResponse.tscn");
var _playerText: PackedScene 	= preload("res://ui/gameplay/PlayerText.tscn");

@export var maxHistoryLength: int = 25;
@onready var historyContainer: VBoxContainer = $"PanelContainer/MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/History";
@onready var _logic: GameLogicController = $"GameLogic";
@onready var _areas: GameAreaController = $"AreaControl";

var currentFloor: PackedScene = null;
var floorRoot: Node = null;

# intro message
func _ready() -> void:
	#PushMessage("Welcome to game. Use the '@' character to access meta commands such as save/load ans start new game.");
	PushGameResponse("Welcome to game.");
	_areas.ChangeArea("test_room");
	_areas.GetCurrentArea().MoveTo(0,0);
	
func CreateHistoryBlock(playerText: String, response: String) -> void:
	var block: Node = HistoryNode.instantiate();
	block.SetPlayerInput(playerText, response);
	historyContainer.add_child(block);
	if (historyContainer.get_child_count() > maxHistoryLength):
			historyContainer.get_child(0).queue_free();

func PushResponseElement(element: ResponseElement) -> void:
	historyContainer.add_child(element);
	if (historyContainer.get_child_count() > maxHistoryLength):
		historyContainer.get_child(0).queue_free();

func PushPlayerInput(playerText: String) -> void:
	var res: ResponseElement = _playerText.instantiate();
	res.SetText(playerText);
	PushResponseElement(res);
	
func PushGameResponse(text: String) -> void:
	var res: ResponseElement = _gameResponse.instantiate();
	res.SetText(text);
	PushResponseElement(res);
	
func PushMessage(msg: String) -> void:
	CreateHistoryBlock("Narration", msg);
	
func AttemptMovement(cmds: PackedStringArray) -> bool:
	if(cmds.size() >= 2):
		cmds[1] = cmds[1].to_lower();
		var dir: Enums.MoveDirection = Enums.MoveDirection.north;
		if(cmds[1] == "north"):
			dir = Enums.MoveDirection.north;
		elif(cmds[1] == "east"):
			dir = Enums.MoveDirection.east;
		elif(cmds[1] == "south"):
			dir = Enums.MoveDirection.south;
		elif(cmds[1] == "west"):
			dir = Enums.MoveDirection.west;
		else:
			return false;
		return _areas.GetCurrentArea().MoveInDirection(dir);
	return false;

func HandleMeta() -> void:
	_areas.ChangeArea("test_room");

func ProcessPlayerInput(msg: String) -> void:
	print(_areas.GetCurrentArea().GetCurrentPosition());
	if (not msg.is_empty()):
		PushPlayerInput(msg);
		var cmds: PackedStringArray = _logic.DeconstructCommand(msg);
		var inputType: Enums.ActionType = _logic.ProcessInputType(cmds[0]);
		if(inputType == Enums.ActionType.movement):
			if(AttemptMovement(cmds)):
				var r: GameRoom = _areas.GetCurrentArea().GetCurrentRoom();
				PushGameResponse("You are now in: " + r.GetName() + ". " + r.GetDescription());
			else:
				PushGameResponse("You can't do that.");
		elif(inputType == Enums.ActionType.meta):
			HandleMeta();
