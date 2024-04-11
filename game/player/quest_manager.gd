extends Node
class_name PlayerQuestManager;

var _quests: Dictionary = {};
var _complete: Array[String] = []; # List of complete quests

func Start(index: String) -> void:
	if(_quests.has(index)):
		printerr("Player has already started quest: " + index);
		return;
	if(not Game.Quests.has(index)):
		printerr("Quest does not exist: " + index);
	_quests[index] = GamePlayerQuest.new(Game.Quests.get(index));
	return;
	
func GetStatus(index: String) -> Enums.QuestStatus:
	if(_quests.has(index)):
		return _quests.get(index).status;
	return Enums.QuestStatus.available;

func Get(index: String) -> GamePlayerQuest:
	if(_quests.has(index)):
		return _quests.get(index);
	return null;

func Has(index: String) -> bool:
	return _quests.has(index);
