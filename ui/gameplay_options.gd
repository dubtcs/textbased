extends Control
class_name GameOptionGrid;

@onready var _container: GridContainer = $"GridContainer";

signal button_entered(button: Button);
signal button_exited(button: Button);

var _buttonScene: PackedScene = preload("res://ui/gameplay/OptionButton.tscn");

const BUTTON_AMOUNT: int = 12;

func AddButton(index: int, desc: String) -> bool:
	var b: Button = get_child(index);
	if(b):
		b.text = desc;
		b.disabled = false;
	return false;

func RemoveButton(index: int) -> void:
	var b: Button = get_child(index);
	if(b):
		b.disabled = true;

func _onMouseEnterButton(but: Button) -> void:
	if(not but.disabled):
		button_entered.emit(but);
	return;
	
func _onMouseExitButton(but: Button) -> void:
	if(not but.disabled):
		button_exited.emit(but);
	return;

func _ready() -> void:
	for i in range(BUTTON_AMOUNT):
		var inst: Button = _buttonScene.instantiate();
		inst.disabled = (i % 2);
		inst.mouse_entered.connect(_onMouseEnterButton.bind(inst));
		inst.mouse_exited.connect(_onMouseExitButton.bind(inst));
		_container.add_child(inst);
