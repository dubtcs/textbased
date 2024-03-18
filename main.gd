extends Control

var HistoryNode: PackedScene = preload("res://ui/gameplay/moment.tscn");

@export var maxHistoryLength: int = 25;
@onready var historyContainer: VBoxContainer = $"PanelContainer/MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/History";
@onready var logic: Node = $"GameLogic";
@onready var roomController: Node = $"RoomControl";

var currentFloor: PackedScene = null;
var floorRoot: Node = null;

# intro message
func _ready() -> void:
	PushMessage("Welcome to game. Play game. Game is simple. Type responses. Move places. Simple as.");
	roomController.ProcessAreas();

func CreateHistoryBlock(playerText: String, response: String) -> void:
	var block: Node = HistoryNode.instantiate();
	block.SetPlayerInput(playerText, response);
	historyContainer.add_child(block);
	if (historyContainer.get_child_count() > maxHistoryLength):
			historyContainer.get_child(0).queue_free();

func PushMessage(msg: String) -> void:
	CreateHistoryBlock("Narration", msg);

func ProcessPlayerInput(msg: String) -> void:
	if (not msg.is_empty()):
		var response: String = logic.ProcessInput(msg);
		CreateHistoryBlock(msg, response);
