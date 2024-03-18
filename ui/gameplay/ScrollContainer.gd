extends ScrollContainer

@onready var bar: VScrollBar = get_v_scroll_bar();

func _ready() -> void:
	bar.changed.connect(ScrollDown);
	
func ScrollDown() -> void:
	#if(scroll_vertical < bar.max_value): # could make it so it only auto scrolls if within 1 page
	scroll_vertical = bar.max_value;
