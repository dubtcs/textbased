extends Node

const FLOOR_SIZE: int = 50;
const CELL_SIZE: int = 64;
const areaFolder: String = "res://world/areas";

@onready var areaNode: Node = $"Areas";

var areaInfo: Dictionary = {};
var currentRoom: GameRoom = null;

var gridMap: AStar2D = AStar2D.new();

func MoveTo(x: int, y: int) -> void:
	return;

func GetCurrentRoom() -> GameRoom:
	return currentRoom;

func ProcessAreas() -> void:
	var dir: DirAccess = DirAccess.open(areaFolder);
	if (dir):
		for filename: String in dir.get_files():
			if(filename.get_extension() == "tscn"):
				var id: String = filename.get_basename();
				if(areaInfo.has(id)):
					printerr("Area ID already exists. " + id);
					continue;
				var areaScene: PackedScene = load(areaFolder + "/" + filename);
				var sceneInstance: Node = areaScene.instantiate();
				ProcessRooms(sceneInstance);
				areaInfo[id] = {};
				areaInfo[id].packedScene = areaScene;
				areaInfo[id].instance = sceneInstance;
				areaNode.add_child(sceneInstance);

func ProcessRooms(floor: Node2D) -> void:
	for item: Node in floor.get_children():
		if (item is GameRoomBridge):
			print("FUCK!");
