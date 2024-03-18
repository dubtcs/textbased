@tool
extends Node2D

class_name GameRoomBridge;

@export var isLateral: bool = true : set = SetIsLateral;

func SetIsLateral(nv: bool) -> void:
	isLateral = nv;
	rotation = deg_to_rad(90.0) if isLateral else 0.0;
