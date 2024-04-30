extends Panel
class_name GameContentContainer;

signal requesting_player();
signal page_changed(controls: bool);

@onready var history: GameResponseHistoryContainer = $"VBoxContainer/Middle/MarginContainer/History";
@onready var quests: GameQuestContainer = $"VBoxContainer/Middle/MarginContainer/Quests";

func PushResponse(msg: String) -> void:
	history.PushResponse(msg);
	return;

func PushInput(title: String = "INPUT") -> GameInputResponse:
	return history.PushInput(title);

func ClearHistory() -> void:
	history.Clear();
	return;

## This just keeps adding them every time but its a visual thing for now
func FillQuests(quests_: PlayerQuestManager) -> void:
	quests.FillQuests(quests_);

func UpdateQuests(quests_: Array[GamePlayerQuest]) -> void:
	quests.UpdateQuests(quests_);

func _UpdateControls(b: bool) -> void:
	page_changed.emit(b);
