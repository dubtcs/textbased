extends Resource
class_name RoomExit;

@export var _exitType: Enums.ExitType = Enums.ExitType.open;
## Item required to use this exit
@export var _key: GameItem = null;

func GetType() -> Enums.ExitType:
	return _exitType;
	
func GetKey() -> GameItem:
	return _key;
