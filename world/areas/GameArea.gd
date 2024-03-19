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

func _ready() -> void:
	var rid: int = 0;
	for item in get_children():
		if(item is GameRoom):
			var pos: Vector2 = Vector2(item.position.x / CELL_SIZE, item.position.y / CELL_SIZE);
			_mapInfo[pos] = { id = rid, instance = item };
			_map.add_point(rid, pos);
			rid += 1;
			var pos2: Vector2 = Vector2.ZERO;
			if(item.canGoNorth):
				pos2 = pos + _movementMapping[Enums.MoveDirection.north];
				_VerifyConnection(pos, pos2);
			if(item.canGoEast):
				pos2 = pos + _movementMapping[Enums.MoveDirection.east];
				_VerifyConnection(pos, pos2);
			if(item.canGoSouth):
				pos2 = pos + _movementMapping[Enums.MoveDirection.south];
				_VerifyConnection(pos, pos2);
			if(item.canGoWest):
				pos2 = pos + _movementMapping[Enums.MoveDirection.west];
				_VerifyConnection(pos, pos2);
		#
	return;

func _VerifyConnection(pos: Vector2, pos2: Vector2) -> void:
	if(_mapInfo.has(pos2)):
		_map.connect_points(_mapInfo[pos].id, _mapInfo[pos2].id, true);
	return;
