extends Resource
class_name GameQuest;

@export var name: String = "";
@export_multiline var description: String = "";
@export var steps: Array[GameQuestStep] = [];

@export var rewards: Array[GameQuestReward] = [];
@export var xp: int = 0;
var index: String = "";
