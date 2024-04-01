extends Resource;
class_name GameRoomOption;

@export var name: String = "";
@export var description: String = "";
@export var buttonIndex: int = 0;
@export_enum("ChangeArea", "Dialogue") var callback = "";
@export var callbackParams: PackedStringArray = [];
