@tool
extends Node2D

class_name GameRoom;

@onready var mIconBox: TextureRect = $"Container/Panel/MarginContainer/Icon";
@onready var mColorPanel: Panel = $"Container/Panel/MarginContainer/Panel";

@export var roomName: String = "";
@export_multiline var roomDescription: String = "";
@export var roomIcon: Enums.RoomIcon = Enums.RoomIcon.empty : set = SetRoomIcon;
@export var roomColor: Enums.RoomColor = Enums.RoomColor.none : set = SetRoomColor;
@export var canGoNorth: bool = true;
@export var canGoEast: bool = true;
@export var canGoSouth: bool = true;
@export var canGoWest: bool = true;

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

func FetchIcon(ico: Enums.RoomIcon) -> CompressedTexture2D:
	if (gIconEnumMap.has(ico)):
		return gIconEnumMap[ico];
	return null;
	
func FetchStylebox(clr: Enums.RoomColor) -> StyleBox:
	if(gColorEnumMap.has(clr)):
		return gColorEnumMap[clr];
	return gColorEnumMap[Enums.RoomColor.none];

func SetRoomIcon(newIcon: Enums.RoomIcon) -> void:
	roomIcon = newIcon;
	var iconLabel: TextureRect = $"Container/Panel/MarginContainer/Icon";
	iconLabel.texture = FetchIcon(roomIcon);
	
func SetRoomColor(newColor: Enums.RoomColor) -> void:
	roomColor = newColor;
	var colorPanel: Panel = $"Container/Panel/MarginContainer/Panel";
	colorPanel.add_theme_stylebox_override("panel", FetchStylebox(roomColor));
