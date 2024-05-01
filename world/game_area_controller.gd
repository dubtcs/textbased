extends Node;
class_name GameAreaController;

const areaFolder: String = "res://world/areas/_use";
const filenameFormat: String = "{n}.tscn";

var _areaInfo: Dictionary = {};

var areaDirectory: DirAccess = DirAccess.open(areaFolder);
var currentAreaIndex: String = "";
var currentArea: GameArea = null;

func AttemptMove(dir: Enums.MoveDirection) -> bool:
	currentArea.GetCurrentRoom().SetAsInactive();
	var didmove: bool = currentArea.MoveInDirection(dir);
	currentArea.GetCurrentRoom().SetAsActive();
	return didmove;	

func MoveTo(x: int, y: int) -> void:
	if(currentArea.GetCurrentRoom()):
		currentArea.GetCurrentRoom().SetAsInactive();	
	currentArea.MoveTo(x,y);
	currentArea.GetCurrentRoom().SetAsActive();
	
func MoveToNamed(roomName: String) -> bool:
	if(currentArea.GetCurrentRoom()):
		currentArea.GetCurrentRoom().SetAsInactive();
	var moved: bool = currentArea.MoveToNamed(roomName);
	currentArea.GetCurrentRoom().SetAsActive();
	return moved;
	
func GetCurrentArea() -> GameArea:
	return currentArea;

## DEPRECATED
func GetArea(name: String) -> GameArea:
	if(_areaInfo.has(name)):
		return _areaInfo[name].instance;
	return null;

func ChangeAreaOld(index: String) -> bool:
	if(_areaInfo.has(index)):
		currentArea.visible = false;
		currentArea = _areaInfo[index].instance;
		currentArea.visible = true;
		return true;
	return false;

func ChangeArea(index: String) -> GameArea:
	if(currentAreaIndex != index):
		var filename: String = filenameFormat.format({n=index});
		if(areaDirectory.file_exists(filename)):
			var scene: PackedScene = load(areaFolder + "/" + filename);
			var area: GameArea = scene.instantiate();
			if(currentArea):
				currentArea.queue_free();
			currentArea = area;
			currentAreaIndex = index;
			return currentArea;
	return null;

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
				currentArea = sceneInstance;
				sceneInstance.name = id;
				#_viewport.AddAreaInstance(sceneInstance);
				currentArea.visible = false; # hide it
