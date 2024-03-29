@tool
extends Node2D

class_name GameRoom;

@export var _roomName: String = "";
@export_multiline var _roomDescription: String = "";
@export var _roomIcon: Enums.RoomIcon = Enums.RoomIcon.empty 	: set = _SetRoomIcon;
@export var _roomColor: Enums.RoomColor = Enums.RoomColor.none 	: set = _SetRoomColor;

@export var _exitNorth: RoomExit = null;
@export var _exitEast: RoomExit = null;
@export var _exitSouth: RoomExit = null;
@export var _exitWest: RoomExit = null;

@onready var _highlight: Panel = $"Container/Panel2";

func GetDescription() -> String:
	return _roomDescription;
	
func GetName() -> String:
	return _roomName;
	
func SetAsActive() -> void:
	_highlight.visible = true;
	
func SetAsInactive() -> void:
	_highlight.visible = false;
	
func GetExit(dir: Enums.MoveDirection) -> RoomExit:
	match(dir):
		Enums.MoveDirection.north: return _exitNorth;
		Enums.MoveDirection.east: return _exitEast;
		Enums.MoveDirection.south: return _exitSouth;
		Enums.MoveDirection.west: return _exitWest;
	return null;

# the "canGo" variables are an effort to not require the bridge class.
# might still want to use bridges, as they allow for keyed entrances and whatnot?

const gColorEnumMap: Dictionary = {
	Enums.RoomColor.none 	: preload("res://world/resources/roomcolors/GameRoomColor.tres") 		as StyleBoxFlat,
	Enums.RoomColor.red 	: preload("res://world/resources/roomcolors/GameRoomColorRed.tres") 	as StyleBoxFlat,
	Enums.RoomColor.blue 	: preload("res://world/resources/roomcolors/GameRoomColorBlue.tres") 	as StyleBoxFlat,
	Enums.RoomColor.yellow 	: preload("res://world/resources/roomcolors/GameRoomColorYellow.tres") 	as StyleBoxFlat,
	Enums.RoomColor.green 	: preload("res://world/resources/roomcolors/GameRoomColorGreen.tres") 	as StyleBoxFlat,
};
const gIconEnumMap: Dictionary = {
	Enums.RoomIcon.bed 		: preload("res://images/bed.png"),
	Enums.RoomIcon.cook 	: preload("res://images/cook.png"),
	Enums.RoomIcon.door 	: preload("res://images/door.png"),
	Enums.RoomIcon.kitchen 	: preload("res://images/pot.png"),
	Enums.RoomIcon.lock 	: preload("res://images/lock.png"),
	Enums.RoomIcon.stairs 	: preload("res://images/stairs.png"),
	Enums.RoomIcon.cpu	 	: preload("res://images/cpu.png"),
	Enums.RoomIcon.circuit 	: preload("res://images/proc.png"),
	Enums.RoomIcon.mouse 	: preload("res://images/mouse.png"),
	Enums.RoomIcon.home 	: preload("res://images/player.png"),
};

## PRIVATE FUNCTIONS

func _FetchIcon(ico: Enums.RoomIcon) -> CompressedTexture2D:
	if (gIconEnumMap.has(ico)):
		return gIconEnumMap[ico];
	return null;
	
func _FetchStylebox(clr: Enums.RoomColor) -> StyleBox:
	if(gColorEnumMap.has(clr)):
		return gColorEnumMap[clr];
	return gColorEnumMap[Enums.RoomColor.none];

func _SetRoomIcon(newIcon: Enums.RoomIcon) -> void:
	_roomIcon = newIcon;
	var iconLabel: TextureRect = $"Container/Panel/MarginContainer/Icon";
	iconLabel.texture = _FetchIcon(_roomIcon);
	
func _SetRoomColor(newColor: Enums.RoomColor) -> void:
	_roomColor = newColor;
	var colorPanel: Panel = $"Container/Panel/MarginContainer/Panel";
	colorPanel.add_theme_stylebox_override("panel", _FetchStylebox(_roomColor));
