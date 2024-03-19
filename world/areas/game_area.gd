extends Node2D
class_name GameArea;

const CELL_SIZE: int = 64;

var _map: AStar2D = AStar2D.new();
var _mapInfo: Dictionary = {};

func _ready() -> void:
	var rid: int = 0;
	for item in get_children():
		if(item is GameRoom):
			var pos: Vector2 = Vector2(item.position.x / CELL_SIZE, item.position.y / CELL_SIZE);
			_mapInfo[pos] = { id = rid, instance = item };
			var pos2: Vector2 = Vector2.ZERO;
			if(item.canGoNorth):
				pos2.x = pos.x;
				pos2.y = pos.y + 1;
				_VerifyConnection(pos, pos2);
			if(item.canGoEast):
				pos2.x = pos.x + 1;
				pos2.y = pos.y;
				_VerifyConnection(pos, pos2);
			if(item.canGoSouth):
				pos2.x = pos.x;
				pos2.y = pos.y - 1;
				_VerifyConnection(pos, pos2);
			if(item.canGoWest):
				pos2.x = pos.x - 1;
				pos2.y = pos.y;
				_VerifyConnection(pos, pos2);
			rid += 1;
		#
	return;
				
func _VerifyConnection(pos: Vector2, pos2: Vector2) -> void:
	if(_mapInfo.has(pos2)):
		_map.connect_points(_mapInfo[pos].id, _mapInfo[pos2].id);
	return;
				
func GetRoom(x: int, y: int) -> GameRoom:
	var pos: Vector2 = Vector2(x, y);
	if(_mapInfo.has(pos)):
		return _mapInfo[pos].instance;	
	return null;
