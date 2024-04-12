extends Panel
class_name GameContentContainer;

signal requesting_player();

@onready var _history: GameResponseHistoryContainer = $"VBoxContainer/Middle/MarginContainer/History";
@onready var _quests: GameQuestContainer = $"VBoxContainer/Middle/MarginContainer/Quests";

func PushResponse(msg: String) -> void:
	_history.PushResponse(msg);
	
func ClearHistory() -> void:
	_history.Clear();
	
## This just keeps adding them every time but its a visual thing for now
func FillQuests(quests: PlayerQuestManager) -> void:
	_quests.FillQuests(quests);
