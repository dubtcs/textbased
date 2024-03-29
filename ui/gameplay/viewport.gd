extends AspectRatioContainer
class_name GameWorldViewport;

@onready var _view: SubViewport = $"SubViewportContainer/SubViewport";
@onready var _camera: Camera2D = $"SubViewportContainer/SubViewport/Camera2D";

func _ready() -> void:
	return;

func MoveCameraTo(pos: Vector2) -> void:
	$"SubViewportContainer/SubViewport/Camera2D".position = pos;

func AddAreaInstance(area: Node) -> void:
	$"SubViewportContainer/SubViewport".add_child(area);
