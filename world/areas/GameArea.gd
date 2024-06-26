extends Node2D
class_name GameArea;

const CELL_SIZE: int = 64;

var _map: AStar2D = AStar2D.new();
var _mapInfo: Dictionary = {};
var _currentRoom: GameRoom = null;
var _currentPos: Vector2 = Vector2.ZERO;

var _bridgeScene: PackedScene = preload("res://world/areas/GameRoomBridge.tscn");
var _bridgeOnewayScene: PackedScene = preload("res://world/areas/GameRoomBridgeOneWay.tscn");

class RoomInfo:
	var id: int;
	var instance: GameRoom;

func GetCurrentRoom() -> GameRoom:
	return _currentRoom;
	
func GetCurrentPosition() -> Vector2:
	return _currentPos;

func GetRoom(x: int, y: int) -> GameRoom:
	var pos: Vector2 = Vector2(x, y);
	return GetRoomVec(pos);
	
func GetRoomNamed(str: String) -> GameRoom:
	return get_node(str);
	# could check to make sure its a GameRoom

func GetRoomVec(pos: Vector2) -> GameRoom:
	if(_mapInfo.has(pos)):
		return _mapInfo[pos].instance;
	return null;

func CanMove(dir: Enums.MoveDirection) -> bool:
	var pos: Vector2 = _currentPos + _movementMapping[dir];
	if(_mapInfo.has(pos)):
		return _map.are_points_connected(_mapInfo[_currentPos].id, _mapInfo[pos].id, false);
	return false;
	
func MoveInDirection(dir: Enums.MoveDirection) -> bool:
	if(CanMove(dir)):
		MoveToPos(_currentPos + _movementMapping[dir]);
		return true;
	return false;
	
func MoveTo(x: int, y: int) -> bool:
	return MoveToPos(Vector2(x,y));
	
func MoveToNamed(roomName: String) -> bool:
	var room: GameRoom = get_node(roomName);
	if(room):
		var pos: Vector2 = Vector2(room.position / CELL_SIZE);
		return MoveToPos(pos);
	return false;
	
func MoveToPos(pos: Vector2) -> bool:
	if(_mapInfo.has(pos)):
		_currentRoom = _mapInfo[pos].instance;
		_currentPos = pos;
		return true;
	printerr("No room found on current area: " + name + " " + str(pos));
	return false;
	
	
	
# PRIVATE FUNCTIONS

## offset of 2 for 64 pixel padding
const _movementMapping: Dictionary = {
	Enums.MoveDirection.north 	: Vector2( 0,-2),
	Enums.MoveDirection.east 	: Vector2( 2, 0),
	Enums.MoveDirection.south 	: Vector2( 0, 2),
	Enums.MoveDirection.west 	: Vector2(-2, 0),
};

const _exitOpposites: Dictionary = {
	Enums.MoveDirection.north	: Enums.MoveDirection.south,
	Enums.MoveDirection.south	: Enums.MoveDirection.north,
	Enums.MoveDirection.west	: Enums.MoveDirection.east,
	Enums.MoveDirection.east	: Enums.MoveDirection.west,
};

func _CreateBridge(from: Vector2, to: Vector2, oneway: bool) -> void:
	var bridge: Node2D = null;
	if(oneway):
		bridge = _bridgeOnewayScene.instantiate();
	else:
		bridge = _bridgeScene.instantiate();
	var toraw: Vector2 = to * CELL_SIZE;
	var fromraw: Vector2 = from * CELL_SIZE
	add_child(bridge);
	bridge.position = fromraw + ((toraw - fromraw) / 2.0);
	bridge.look_at(fromraw);
	return;

func _ProcessExits() -> void:
	for pos: Vector2 in _mapInfo:
		var id: int = _mapInfo[pos].id;
		var room: GameRoom = _mapInfo[pos].instance;
		for dir in Enums.MoveDirection.values():
			var override: RoomExit = room.GetExit(dir);
			var pos2: Vector2 = pos + _movementMapping[dir];
			if(_mapInfo.has(pos2)):
				var room2: GameRoom = _mapInfo[pos2].instance;
				var id2: int = _mapInfo[pos2].id;
				if(override):
					if(override.GetType() == Enums.ExitType.closed):
						# Make sure the other connection is valid
						var opposite: Enums.MoveDirection = _exitOpposites[dir];
						var otherExit: RoomExit = room2.GetExit(opposite);
						if(otherExit): # other room has an override
							if(otherExit.GetType() == Enums.ExitType.closed): # it's closed, too so don't create an exit
								continue;
						# remove 2 way if one has been made
						if(_map.are_points_connected(id, id2)):
							_map.disconnect_points(id, id2);
						_CreateBridge(pos, pos2, true); # otherwise make the bridge instance
						_map.connect_points(id2, id, false);
					else:
						print("Keyed Door.");
				else:
					# not used to prevent one way overwrite
					if(not _map.are_points_connected(id, id2, false)):
						_map.connect_points(id, id2);
						_CreateBridge(pos, pos2, false);

func _ProcessRooms() -> void:
	var rid: int = 0;
	for item in get_children():
		if(item is GameRoom):
			var pos: Vector2 = Vector2(item.position.x / CELL_SIZE, item.position.y / CELL_SIZE);
			_mapInfo[pos] = { id = rid, instance = item };
			_map.add_point(rid, pos);
			rid += 1;
		#
	return;

func _ready() -> void:
	_ProcessRooms();
	_ProcessExits();
