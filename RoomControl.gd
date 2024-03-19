extends Node

const FLOOR_SIZE: int = 50;
const CELL_SIZE: int = 64;
const areaFolder: String = "res://world/areas";

@onready var areaNode: Node = $"Areas";

var _areaInfo: Dictionary = {};
var _currentArea: String = "";
var _currentRoom: GameRoom = null;

var gridMap: AStar2D = AStar2D.new();

func MoveTo(x: int, y: int) -> void:
	var pos: Vector2 = Vector2(x,y);
	if(_areaInfo[_currentArea].rooms.has(pos)):
		_currentRoom = _areaInfo[_currentArea].rooms[pos].instance;
	return;

func GetCurrentRoom() -> GameRoom:
	return _currentRoom;

func ProcessAreas() -> void:
	var dir: DirAccess = DirAccess.open(areaFolder);
	if (dir):
		for filename: String in dir.get_files():
			if(filename.get_extension() == "tscn"):
				var id: String = filename.get_basename();
				if(_areaInfo.has(id)):
					printerr("Area ID already exists. " + id);
					continue;
				_currentArea = id;
				var areaScene: PackedScene = load(areaFolder + "/" + filename);
				var sceneInstance: Node = areaScene.instantiate();
				_areaInfo[id] = { map = AStar2D.new(), rooms = {} };
				_areaInfo[id].packedScene = areaScene;
				_areaInfo[id].instance = sceneInstance;
				ProcessRooms(sceneInstance);
				areaNode.add_child(sceneInstance);

func _VerifyConnection(id: int, otherPos: Vector2) -> void:
	if(_areaInfo[_currentArea].rooms.has(otherPos)):
		_areaInfo[_currentArea].map.connect_points(id, _areaInfo[_currentArea].rooms[otherPos].id);
	return;

func ProcessRooms(floor: Node2D) -> void:
	var map: AStar2D = _areaInfo[_currentArea].map;
	var rooms: Dictionary = _areaInfo[_currentArea].rooms;
	var rid: int = 0;
	for item: Node in floor.get_children():
		if(item is GameRoom):
			_currentRoom = item;
			var pos: Vector2 = Vector2(item.position.x / CELL_SIZE, item.position.y / CELL_SIZE);
			_areaInfo[_currentArea].rooms[pos] = {
				id = rid,
				instance = item,
			};
			if(item.canGoNorth):
				var pos2: Vector2 = Vector2(pos.x, pos.y + 1);
				_VerifyConnection(rid, pos2);
			if(item.canGoEast):
				var pos2: Vector2 = Vector2(pos.x + 1, pos.y);
				_VerifyConnection(rid, pos2);
			if(item.canGoSouth):
				var pos2: Vector2 = Vector2(pos.x, pos.y - 1);
				_VerifyConnection(rid, pos2);
			if(item.canGoWest):
				var pos2: Vector2 = Vector2(pos.x - 1, pos.y);
				_VerifyConnection(rid, pos2);
			rid += 1;
	return;
