extends Panel
class_name GameContentContainer;

signal requesting_player();

@onready var _history: GameResponseHistoryContainer = $"VBoxContainer/Middle/MarginContainer/History";
@onready var _quests: VBoxContainer = $"VBoxContainer/Middle/MarginContainer/Quests/HBoxContainer/ScrollContainer/VBoxContainer";

func PushResponse(msg: String) -> void:
	_history.PushResponse(msg);
	
func ClearHistory() -> void:
	_history.Clear();
	
## This just keeps adding them every time but its a visual thing for now
func UpdateQuests(quests: PlayerQuestManager) -> void:
	for index: String in quests._quests:
		var cur: GameQuest = Game.Quests.get(index);
		var but: Button = Button.new();
		but.name = index;
		but.text = cur.name;
		but.focus_mode = Button.FOCUS_NONE;
		_quests.add_child(but);
