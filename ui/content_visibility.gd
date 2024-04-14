extends VBoxContainer

@onready var container: MarginContainer = $"Middle/MarginContainer";
@onready var options: GridContainer = $"Options/GridContainer";

signal page_changed(controlsEnabled: bool);

var styleSelected: StyleBoxFlat = preload("res://ui/ptheme/stylebox/button_options/focus.tres");
var styleNone: StyleBoxFlat = preload("res://ui/ptheme/stylebox/button_options/normal.tres");

var current: String = "History";

func SwitchToPage(index: String) -> void:
	var page: Node = container.get_node(current);
	var button: Button = options.get_node(current);
	if(page):
		page.visible = false;
		page_changed.emit(index == "History");
	if(button):
		button.add_theme_stylebox_override("normal", styleNone);
	
	current = index;
	page = container.get_node(index);
	button = options.get_node(index);
	if(page):
		page.visible = true;
	if(button):
		button.add_theme_stylebox_override("normal", styleSelected);
		button.add_theme_stylebox_override("hover", styleSelected);

func _ready() -> void:
	for child in options.get_children():
		if(child is Button):
			child.connect("pressed", SwitchToPage.bind(child.name));
	SwitchToPage("History");
