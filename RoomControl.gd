extends Node;
class_name GameAreaController;

@export var _viewport: GameWorldViewport = null;

const areaFolder: String = "res://world/areas/_use";

var _areaInfo: Dictionary = {};
var _currentArea: GameArea = null;

func AttemptMove(dir: Enums.MoveDirection) -> bool:
	if(_currentArea.CanMove(dir)):
		_currentArea.GetCurrentRoom().SetAsInactive();
		if(_currentArea.MoveInDirection(dir)):
			_viewport.MoveCameraTo(_currentArea.GetCurrentRoom().position);
		_currentArea.GetCurrentRoom().SetAsActive();
		return true;
	return false;

func MoveTo(x: int, y: int) -> void:
	if(_currentArea.GetCurrentRoom()):
		_currentArea.GetCurrentRoom().SetAsInactive();	
	_currentArea.MoveTo(x,y);
	_viewport.MoveCameraTo(_currentArea.GetCurrentRoom().position);
	_currentArea.GetCurrentRoom().SetAsActive();
	
func MoveToNamed(roomName: String) -> void:
	if(_currentArea.GetCurrentRoom()):
		_currentArea.GetCurrentRoom().SetAsInactive();
	_currentArea.MoveToNamed(roomName);
	_viewport.MoveCameraTo(_currentArea.GetCurrentRoom().position);
	_currentArea.GetCurrentRoom().SetAsActive();
	
func GetCurrentArea() -> GameArea:
	return _currentArea;

func GetArea(name: String) -> GameArea:
	if(_areaInfo.has(name)):
		return _areaInfo[name].instance;
	return null;

func ChangeArea(nam: String) -> bool:
	if(_areaInfo.has(nam)):
		_currentArea.visible = false;
		_currentArea = _areaInfo[nam].instance;
		_currentArea.visible = true;
		return true;
	return false;

# PRIVATE

func _ready() -> void:
	_ProcessAreas();

func _ProcessAreas() -> void:
	var dir: DirAccess = DirAccess.open(areaFolder);
	if (dir):
		for filename: String in dir.get_files():
			if(filename.get_extension() == "tscn"):
				var id: String = filename.get_basename();
				if(_areaInfo.has(id)):
					printerr("Area ID already exists. " + id);
					continue;
				var areaScene: PackedScene = load(areaFolder + "/" + filename);
				var sceneInstance: Node = areaScene.instantiate();
				_areaInfo[id] = {  };
				_areaInfo[id].packedScene = areaScene;
				_areaInfo[id].instance = sceneInstance;
				_currentArea = sceneInstance;
				sceneInstance.name = id;
				_viewport.AddAreaInstance(sceneInstance);
				_currentArea.visible = false; # hide it
