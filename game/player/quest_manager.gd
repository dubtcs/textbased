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

func UpdateFlagQuests(flag: String) -> void:
	for index: String in _flagSteps.keys():
		var pq: GamePlayerQuest = _quests.get(index);
		var step: GameQuestStep = pq.instance.steps[pq.step];
		if(step is GameQuestStepFlag):
			print(flag);
			print(step.flag);
			if(flag == step.flag):
				RemoveQuestFromContainer(pq);
				pq.step += 1;
				if(pq.step >= pq.instance.steps.size()):
					pq.status = Enums.QuestStatus.complete;
				else:
					AddQuestToContainer(pq);
		else:
			printerr("Quest step is no expected type.");
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
