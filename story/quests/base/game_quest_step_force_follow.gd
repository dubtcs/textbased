extends GameQuestStep;
class_name GameQuestStepForceFollow;

# Used to force the character into a path
# Best used when talking with an npc or some shit
# Like trigger this INSTANTLY after completing an NPC flag dialogue step

@export var toArea: String = "";
@export var toRoom: String = "";
