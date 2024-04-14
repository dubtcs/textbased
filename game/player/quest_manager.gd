extends Node
class_name PlayerQuestManager;

var _quests: Dictionary = {};
var _complete: Array[String] = []; # List of complete quests

var _flagSteps: Dictionary = {};

func Start(index: String) -> void:
	if(_quests.has(index)):
		printerr("Player has already started quest: " + index);
		return;
	if(not Game.Quests.has(index)):
		printerr("Quest does not exist: " + index);
	_quests[index] = GamePlayerQuest.new(Game.Quests.get(index), index);
	AddQuestToContainer(_quests[index]);
	return;
	
func RemoveQuestFromContainer(playerQuest: GamePlayerQuest) -> void:
	var q: GameQuest = playerQuest.instance;
	var step: GameQuestStep = q.steps[playerQuest.step];
	if(step is GameQuestStepFlag):
		if(_flagSteps.has(playerQuest.index)):
			_flagSteps.erase(playerQuest.index);
	elif(step is GameQuestStepItem):
		print(22);

func AddQuestToContainer(playerQuest: GamePlayerQuest) -> void:
	var q: GameQuest = playerQuest.instance;
	var step: GameQuestStep = q.steps[playerQuest.step];
	if(step is GameQuestStepFlag):
		_flagSteps[playerQuest.index] = true;
	elif(step is GameQuestStepItem):
		print(22);

func UpdateFlagQuests(flags: PlayerFlagManager) -> Array[GamePlayerQuest]:
	var rv: Array[GamePlayerQuest] = [];
	for index: String in _flagSteps.keys():
		var pq: GamePlayerQuest = _quests.get(index);
		UpdateFlagSingleQuest(pq, flags);
		rv.push_back(pq);
	return rv;
	
func UpdateFlagSingleQuest(quest: GamePlayerQuest, flags: PlayerFlagManager) -> void:
	if(quest.status != Enums.QuestStatus.complete):
		var step: GameQuestStep = quest.instance.steps[quest.step];
		if(flags.Check(step.flag)):
			RemoveQuestFromContainer(quest);
			quest.step += 1;
			if(quest.step >= quest.instance.steps.size()):
				quest.status = Enums.QuestStatus.complete;
			else:
				AddQuestToContainer(quest);
				UpdateFlagSingleQuest(quest, flags); ## Next flag might already be done
	else:
		printerr("Quest already complete: " + quest.instance.name);
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
