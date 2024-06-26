extends Control
class_name GameOptionGrid;

@onready var _container: GridContainer = $"GridContainer";

signal button_activated(optionIndex: int);
signal button_entered(button: GameOptionButton);
signal button_exited(button: GameOptionButton);

var _buttonScene: PackedScene = preload("res://ui/gameplay/OptionButton.tscn");

const BUTTON_AMOUNT: int = 12;

func AddButton(option: GameRoomOption, optionIndex: int) -> bool:
	var b: GameOptionButton = _container.get_child(optionIndex);
	if(b):
		b.text = option.name;
		b.disabled = false;
		b.rawOptionIndex = optionIndex;
		if(b.get_rect().has_point(get_local_mouse_position())): # Update the hint if needed
			button_entered.emit(b);
	return false;
	
func AddUIButton(option: GameUIOption, index: int) -> void:
	var but: GameOptionButton = _container.get_child(index);
	if(but):
		but.text = option.title;
		but.rawOptionIndex = index;
		but.disabled = false;
		if(but.get_rect().has_point(get_local_mouse_position())): # Update the hint if needed
			button_entered.emit(but);
	return;

func RemoveButton(index: int) -> void:
	var b: GameOptionButton = _container.get_child(index);
	if(b):
		b.disabled = true;

func ClearButtons() -> void:
	for b in _container.get_children():
		if(b is GameOptionButton):
			b.disabled = true;
	button_exited.emit(null); ## Used to hide the hint after selecting an option

func _onButtonActivated(but: GameOptionButton) -> void:
	button_activated.emit(but.rawOptionIndex);
	return;

func _onMouseEnterButton(but: GameOptionButton) -> void:
	if(not but.disabled):
		button_entered.emit(but);
	return;
	
func _onMouseExitButton(but: GameOptionButton) -> void:
	if(not but.disabled):
		button_exited.emit(but);
	return;

func _ready() -> void:
	for i in range(BUTTON_AMOUNT):
		var inst: GameOptionButton = _buttonScene.instantiate();
		inst.disabled = true;
		inst.mouse_entered.connect(_onMouseEnterButton.bind(inst));
		inst.mouse_exited.connect(_onMouseExitButton.bind(inst));
		inst.pressed.connect(_onButtonActivated.bind(inst));
		_container.add_child(inst);
