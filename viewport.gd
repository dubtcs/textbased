extends Control

@onready var _areaControl: GameAreaController = $"Panel/MarginContainer/VBoxContainer/PlayerInfo/Panel/AreaControl";
@onready var _camera: Camera2D = $"Panel/MarginContainer/VBoxContainer/PlayerInfo/Panel/SubViewportContainer/SubViewport/Camera2D";
@onready var _buttons: GridContainer = $"Panel/MarginContainer/VBoxContainer/PlayerInfo/Options/MarginContainer/GridContainer";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_areaControl.ChangeArea("test_room");
	_areaControl.GetCurrentArea().MoveTo(0,0);
	MoveCamera();
	for item in _buttons.get_children():
		if (item is Button):
			item.pressed.connect(OnMoveToScenePress.bind(item));
	
func OnMoveToScenePress(but: Button) -> void:
	_areaControl.ChangeArea(but.text);
	_areaControl.GetCurrentArea().MoveTo(0,0);
	MoveCamera();
	return;
	
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("moveNorth")):
		_areaControl.AttemptMove(Enums.MoveDirection.north);
	elif(event.is_action_pressed("moveEast")):
		_areaControl.AttemptMove(Enums.MoveDirection.east);
	elif(event.is_action_pressed("moveSouth")):
		_areaControl.AttemptMove(Enums.MoveDirection.south);
	elif(event.is_action_pressed("moveWest")):
		_areaControl.AttemptMove(Enums.MoveDirection.west);
	MoveCamera();
	return;

func MoveCamera() -> void:
	var pos: Vector2 = _areaControl.GetCurrentArea().GetCurrentRoom().position;
	_camera.position = pos;
