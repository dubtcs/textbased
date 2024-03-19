extends Node;

const areaFolder: String = "res://world/areas/_use";

@onready var areaNode: Node = $"Areas";

var _areaInfo: Dictionary = {};
var _currentArea: String = "";

func GetArea(name: String) -> GameArea:
	if(_areaInfo.has(name)):
		return _areaInfo[name].instance;
	return null;

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
				_areaInfo[id] = {  };
				_areaInfo[id].packedScene = areaScene;
				_areaInfo[id].instance = sceneInstance;
				sceneInstance.name = id;
				areaNode.add_child(sceneInstance);
	var ar: GameArea = GetArea("test_room");
	print(ar.GetRoom(0,0).GetDescription());
	print(ar.GetRoom(2,0).GetDescription());
	print(ar.MoveTo(0,0));
	print(ar.CanMove(Enums.MoveDirection.east));
	print(ar.CanMove(Enums.MoveDirection.west));
	print(ar.GetCurrentPosition());
	ar.MoveInDirection(Enums.MoveDirection.east);
	print(ar.GetCurrentPosition());
	
	
