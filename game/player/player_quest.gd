extends Resource
class_name GamePlayerQuest;

var instance: GameQuest = null;
var step: int = 0;
var status: Enums.QuestStatus = Enums.QuestStatus.available;
var index: String = "";

func _init(questInstance: GameQuest, indexn: String, stepn: int = 0, statusn: Enums.QuestStatus = Enums.QuestStatus.inProgress) -> void:
	instance = questInstance;
	step = stepn;
	status = statusn;
	index = indexn;
