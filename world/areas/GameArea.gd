@tool
extends Node2D
class_name GameArea;

const CELL_SIZE: int = 64;

var _map: AStar2D = AStar2D.new();
var _mapInfo: Dictionary = {};
var _currentRoom: GameRoom = null;
var _currentPos: Vector2 = Vector2.ZERO;

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
	
	#why tf did I do this??
	#var room: GameRoom = get_node(str);
	#if(room):
		#var pos: Vector2 = Vector2(room.position.x / CELL_SIZE, room.position.y / CELL_SIZE);
		#return GetRoomVec(pos);
	#return null;

func GetRoomVec(pos: Vector2) -> GameRoom:
	if(_mapInfo.has(pos)):
		return _mapInfo[pos].instance;	
	return null;

func CanMove(dir: Enums.MoveDirection) -> bool:
	var pos: Vector2 = _currentPos + _movementMapping[dir];
	if(_mapInfo.has(pos)):
		return _map.are_points_connected(_mapInfo[_currentPos].id, _mapInfo[pos].id);
	return false;
	
func MoveInDirection(dir: Enums.MoveDirection) -> bool:
	if(CanMove(dir)):
		MoveToPos(_currentPos + _movementMapping[dir]);
		return true;
	return false;
	
func MoveTo(x: int, y: int) -> bool:
	return MoveToPos(Vector2(x,y));
	
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
	Enums.MoveDirection.north 	: Vector2( 0, 2),
	Enums.MoveDirection.east 	: Vector2( 2, 0),
	Enums.MoveDirection.south 	: Vector2( 0,-2),
	Enums.MoveDirection.west 	: Vector2(-2, 0),
};

func _ProcessExits(room: GameRoom, pos: Vector2) -> void:
	var pos2: Vector2 = Vector2.ZERO;
	for iter in Enums.MoveDirection.values():
		var dir: RoomExit = room.GetExit(iter);
		pos2 = pos + _movementMapping[iter];
		if(_mapInfo.has(pos2)):
			if(dir): # override, like closed or keyed
				print("Bruh.");
			else: # open path
				_map.connect_points(_mapInfo[pos].id, _mapInfo[pos2].id);
	return;

func _ProcessRooms() -> void:
	var rid: int = 0;
	for item in get_children():
		if(item is GameRoom):
			var pos: Vector2 = Vector2(item.position.x / CELL_SIZE, item.position.y / CELL_SIZE);
			_mapInfo[pos] = { id = rid, instance = item };
			_map.add_point(rid, pos);
			_ProcessExits(item, pos);
			rid += 1;
		#
	return;
				
func _ready() -> void:
	_ProcessRooms();

func _VerifyConnection(pos: Vector2, pos2: Vector2) -> void:
	if(_mapInfo.has(pos2)):
		_map.connect_points(_mapInfo[pos].id, _mapInfo[pos2].id, true);
	return;
