extends GameQuestStep
class_name GameQuestStepKill;

@export var npcId: String = "";
@export_range(1,100) var killCount: int = 1;
